#!/usr/bin/perl 
package Twitter;

use MIME::Base64;
use LWP::UserAgent;
use JSON qw( decode_json );

sub new
{
    my $class = shift;
    my $self = {
        _consumerKey 	=> shift,
        _consumerSecret => shift,
        _credentials    => shift,
		_token 			=> shift,
		_error      	=> shift,
	};
	bless $self, $class;
    return $self;
}

sub authorizeToken {
	my ( $self ) = @_;   	
	$self->prepareCredentials();
	$self->exchangeToken();
}

sub getToken {
	my ( $self ) = @_;   	
	return $self->{_token};
}

sub getError {
	my ( $self ) = @_;   	
	return $self->{_error};
}

sub prepareCredentials {
	my ( $self ) = @_;
	my $consumerKey = $self->{_consumerKey};
	my $consumerSecret = $self->{_consumerSecret};
	my $credentials = $consumerKey .":". $consumerSecret;
	$self->{_credentials} = encode_base64($credentials);
	return $self->{_credentials};
}

sub exchangeToken {
	my ( $self ) = @_;
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
		$self->{_token} = $decoded->{'access_token'};
		$self->{_error} = undef;
		return $self->{_token};
	}
	else {
		$self->{_error} = "token error";
		return $self->{_error};
	}
}

1;
