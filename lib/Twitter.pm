########################################################################
#
# File   :  Twitter.pm
# History:  23-Jan-2015 first implementation of the Twitter package
#               26-Jan-2015 final implementation of the Twitter
#                       module, including testing.
# Author: Selva Valluvan <pvalluva@uwaterloo.ca>
#
########################################################################
#
# This module has one object and has its own methods.
# Comments are provided at plces needed.
#
########################################################################

package Twitter;

use MIME::Base64;
use LWP::UserAgent;
use JSON qw( decode_json );

sub new
{
      my $class = shift;
      my $self = {
            _consumerKey        => shift,
            _consumerSecret    => shift,
            _credentials             => shift,
            _token 	             => shift,
            _error      	        => shift,
      };
      bless $self, $class;
      return $self;
}

sub getToken {
      my ( $self ) = @_;
      return $self->{_token};
}

sub getError {
      my ( $self ) = @_;
      return $self->{_error};
}

sub authorizeToken {
      my ( $self ) = @_;
      $self->prepareCredentials();
      $self->exchangeToken();
}

# ConsumerKey and ConsumerSecret from the application registered with Twitter
#encoding the credentials to Base64 as mentioned in Twitter RFC.
sub prepareCredentials {
      my ( $self ) = @_;
      my $consumerKey = $self->{_consumerKey};
      my $consumerSecret = $self->{_consumerSecret};
      if ($consumerKey ne "" && $consumerSecret ne  "" ) {
            my $credentials = $consumerKey .":". $consumerSecret;
            $self->{_credentials} = encode_base64($credentials);
            $self->{_error} = undef;
            return $self->{_credentials};
      } else {
            $self->{_error} = '{"errors":[{"message":"Unprocessable ConsumerKey or ConsumerSecret"}]}';
            return $self->{_error};
      }

}

sub exchangeToken {
      my ( $self ) = @_;
      if (not defined$self->{_error}) {
            my $credentials = $self->{_credentials};
            my $ua = LWP::UserAgent->new;
            my $server_endpoint = "https://api.twitter.com/oauth2/token";

            # set custom HTTP request header fields
            my $req = HTTP::Request->new(POST => $server_endpoint);
            $req->header('Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8');
            $req->header('Authorization' => 'Basic '.$credentials);
            $req->header('Content-Length' => '29');
            $req->header('Accept-Encoding' => 'gzip');
            # add POST data to HTTP request body
            my $post_data = 'grant_type=client_credentials';
            $req->content($post_data);

            my $resp = $ua->request($req);
            if ($resp->is_success) {
                  my $message = $resp->decoded_content;
                  my $decoded = decode_json($message);
                  $self->{_token} = $decoded->{'access_token'};         #prasing the response and get the token only.
                  $self->{_error} = undef;
                  return $self->{_token};
            }
            else {
                  my $message = $resp->decoded_content;
                  $self->{_error} = $message;
                  return $self->{_error};
            }
      } else {
            return $self->{_error};
      }
}

1;
