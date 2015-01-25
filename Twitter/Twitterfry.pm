#!/usr/bin/perl 
package Twitterfry;

use LWP::UserAgent;
use JSON qw( decode_json );


sub new
{
    my $class = shift;
    my $self = {
        _token 		=> shift,
        _screenName => shift,
		_count 		=> shift,
		_result		=> shift,
        _error      => shift,
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
		$self->{_error} = "Token is needed for Request";
	}elsif($screenName eq ""){
		$self->{_error} = "ScreenName is needed for Request";
	}
}

sub getTweets {
	my ( $self ) = @_;
	my $token = $self->{_token};
	my $screenName = @{$self->{_screenName}}[0];
	my $count = (defined $self->{_count}) ? $self->{_count} : 10;
    my $ua = LWP::UserAgent->new;

	$self->validate();
	if(not defined $self->{_error}){
		my $server_endpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=$count&screen_name=$screenName";

		# set custom HTTP request header fields
		my $req = HTTP::Request->new(GET => $server_endpoint);
		$req->header('Authorization' => 'Bearer '.$token);
		$req->header('Accept-Encoding' => 'gzip');
		# add POST data to HTTP request body

		my $resp = $ua->request($req);
		my $message = $resp->decoded_content;
		my $decoded = decode_json($message);
		if ($resp->is_success) {
			$self->{_result} = $message;
			$self->{_error} = undef;
			return $self->{_result};
		}
		else {
			$self->{_error} = $decoded->{'errors'};
		}
	}
}

sub getCommonFollowings {
	my ( $self ) = @_;
	my $token = $self->{_token};
	my $screenName = $self->{_screenName};
	my $count = (defined $self->{_count}) ? $self->{_count} : 20;

	my ($firstTweety, $error) = getFollowings($token, @{$screenName}[0], $count);
	my ($secondTweety, $error) = getFollowings($token, @{$screenName}[1], $count);

	if(not defined $error){
		my @firstIds = extractArrays($firstTweety);
		my @secondIds = extractArrays($secondTweety);
		#my @intesection = findIntersection(@firstIds, @secondIds);
		my @intesection = qw();
		my %count = ();
		foreach my $element (@firstIds, @secondIds) { $count{$element}++ }
		foreach my $element (keys %count) {
    		push @intesection, $element;
		}
		$self->{_result} = @intesection;
	}else{
		my $decoded = decode_json($error);
		$self->{_error} = $decoded->{'errors'};
	}
}

sub getFollowings {
	my $token = shift;
	my $screenName = shift;
	my $count = shift;
	my $ua = LWP::UserAgent->new;

	my $server_endpoint = "https://api.twitter.com/1.1/friends/list.json?screen_name=$screenName&count=$count";

	# set custom HTTP request header fields
	my $req = HTTP::Request->new(GET => $server_endpoint);
	$req->header('Authorization' => 'Bearer '.$token);
	$req->header('Accept-Encoding' => 'gzip');

	my $resp = $ua->request($req);
	if ($resp->is_success) {
		my $message = $resp->decoded_content;
		return ($message, undef);
	}
	else {
		my $error = $resp->decoded_content;
		return (undef, $error);
	}
}

sub extractArrays {
	my $tweety = shift;
	my @union = qw();

	my $decoded = decode_json($tweety);
	my @friends = @{ $decoded->{'users'} };
	foreach my $f ( @friends ) {
  		my $ids = $f->{"id"};
  		push @union, $ids;
	}
	return @union;
}

sub findIntersection {
	my @array1 = shift;
	my @array2 = shift;
	my @intesection = qw();
	my %count = ();

	foreach my $element (@array1, @array2) { $count{$element}++ }
	foreach my $element (keys %count) {
    	push @intesection, $element;
	}

	return @intersection
}

sub parseJson_Followings {
	my $inuptJson = shift;
	my @intersection = shift;

	my $decoded = decode_json($inuptJson);
	my @friends = @{ $decoded->{'users'} };
	for($i=0; $a<@friends; $a++ ){

	}

}

1;
