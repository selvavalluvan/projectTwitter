########################################################################
#
# File   :  TwitterFry.pm
# History:  23-Jan-2015 first implementation of the TwitterFry package
#               26-Jan-2015 final implementation of the TwitterFry
#                       module, including testing.
# Author: Selva Valluvan <pvalluva@uwaterloo.ca>
#
########################################################################
#
# This module has one object and has its own methods.
# Comments are provided at plces needed.
#
########################################################################

package TwitterFry;

use LWP::UserAgent;
use JSON qw( decode_json );
use Encode qw(decode encode);

sub new
{
      my $class = shift;
      my $self = {
            _token 		=> shift,
            _screenName => shift,
            _count 		=> shift,
            _result		=> shift,
            _error            => shift,
      };

      bless $self, $class;
      return $self;
}

sub getToken {
      my ( $self ) = @_;
      return $self->{_token};
}

sub getScreenName {
      my ( $self ) = @_;
      return $self->{_screenName};
}

sub getCount {
      my ( $self ) = @_;
      return $self->{_count};
}

sub getResult {
      my ( $self ) = @_;
      return $self->{_result};
}

sub getError {
      my ( $self ) = @_;
      return $self->{_error};
}

sub validate {
      my ( $self ) = @_;
      my $token = $self->{_token};
      my $screenName = $self->{_screenName};
      if($token eq ""){
            $self->{_error} = '{"errors":[{"message":"Token is shouldnot be empty"}]}';
      }elsif($screenName eq ""){
            $self->{_error} = '{"errors":[{"message":"ScreenName is should not be empty"}]}';
      }
}

sub getTweets {
      my ( $self ) = @_;
      my $token = $self->{_token};
      my $screenName = @{$self->{_screenName}}[0];
      my $count = (defined $self->{_count}) ? $self->{_count} : 20;                 # providing a default count if the calling function doesnot provide one.
      my $ua = LWP::UserAgent->new;

      $self->validate();
      if(not defined $self->{_error}){
            my $server_endpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=$count&screen_name=$screenName";

            # set custom HTTP request header fields
            my $req = HTTP::Request->new(GET => $server_endpoint);
            $req->header('Authorization' => 'Bearer '.$token);
            $req->header('Accept-Encoding' => 'gzip');

            my $resp = $ua->request($req);
            my $message = $resp->decoded_content;
            if ($resp->is_success) {
                  if ($message ne "[]") {                                                 #twitter gives back a 200 message with empty array if there is no such user on twitter. That's wierd!! So, Checking if its an empty array and throw error.
                        $encodedResult = encode("utf8", $message);
                        $self->{_result} = $encodedResult;
                        $self->{_error} = undef;
                        return $self->{_result};
                  } else {
                        $self->{_error} =  '{"errors":[{"message":"No such user on Twitter"}]}';
                        return $self->{_error};
                  }
            }
            else {
                  $self->{_error} = $message;
                  return $self->{_error};
            }
      } else {
            return $self->{_error};
      }
}

# The json parsing part of this method is a tricky one. Twitter gives back invalid json sometimes.
#So parsing only the needed data and casting to uft8 to get unicode characters properly and finding the intesection between both users.
sub getCommonFollowings {
      my ( $self ) = @_;
      my $token = $self->{_token};
      my $screenName = $self->{_screenName};
      my $count = (defined $self->{_count}) ? $self->{_count} : 200;   # providing a default count if the calling function doesnot provide one.

      $self->validate();
      if(not defined $self->{_error}){
            my ($firstTweety, $error) = getFollowings($token, @{$screenName}[0], $count);
            my ($secondTweety, $error) = getFollowings($token, @{$screenName}[1], $count);

            if(not defined $error){
                  my $data1 = decode_json($firstTweety);
                  my $data2 = decode_json($secondTweety);

                  my $aref1 = $data1->{users};
                  my @entryarray1;
                  for my $element (@$aref1) {
                        $entry = '{"id":"'. $element->{id_str}.'","name":"'. encode("utf8",$element->{name}).'","screen_name":"'. encode("utf8",$element->{screen_name}).'","description":"'. encode("utf8",$element->{description}).'","profile_image_url":"'. encode("utf8",$element->{profile_image_url}).'"}'."\n";
                        push @entryarray1, $entry;
                  }

                  my $aref2 = $data2->{users};
                  my @entryarray2;
                  for my $element (@$aref2) {
                        $entry = '{"id":"'. $element->{id_str}.'","name":"'. encode("utf8",$element->{name}).'","screen_name":"'. encode("utf8",$element->{screen_name}).'","description":"'. encode("utf8",$element->{description}).'","profile_image_url":"'. encode("utf8",$element->{profile_image_url}).'"}'."\n";
                        push @entryarray2, $entry;
                  }

                  my %count = ();
                  foreach my $element (@entryarray1, @entryarray2) {
                        $count{$element}++;
                  }
                  my @intersect  = grep { $count{$_} == 2 } keys %count;
                  my $preEncoded = join(', ', @intersect);
                  $preEncoded = "{\"result\":[". $preEncoded."]}";
                  $encodedResult = encode("utf8", $preEncoded);
                  $self->{_result} = $encodedResult;
                  $self->{_error} = undef;
                  return $self->{_result};
            }else{
                  $self->{_error} = $error;
                  return $self->{_error};
            }
      } else {
            return $self->{_error};
      }
}

sub getFollowings {
      my $token = shift;
      my $screenName = shift;
      my $count = shift;
      my $ua = LWP::UserAgent->new;

      my $server_endpoint = "https://api.twitter.com/1.1/friends/list.json?screen_name=$screenName&count=$count";

      my $req = HTTP::Request->new(GET => $server_endpoint);
      $req->header('Authorization' => 'Bearer '.$token);
      $req->header('Accept-Encoding' => 'gzip');

      my $resp = $ua->request($req);
      if ($resp->is_success) {
            my $message = $resp->decoded_content;
            if ($message ne "[]") {                                                 #twitter gives back a 200 message with empty array if there is no such user on twitter. That's wierd!! So, Checking if its an empty array and throw error.
                  return ($message, undef);
            } else {
                  my $error = '{"errors":[{"message":"No such user on Twitter"}]}';
                  return (undef, $error);
            }
      }
      else {
            my $error = $resp->decoded_content;
            return (undef, $error);
      }
}

1;
