#!/usr/bin/perl

use Dancer;
use LWP::UserAgent;
use JSON qw( decode_json );
use lib "./Twitter";
use Twitter;
use Twitterfry;
 
set public => path(dirname(__FILE__), './static');

get '/' => sub{
     send_file '/index.html'
};

sub generateToken {
	my $object = new Twitter( "5cPwb38Auf4y1U6vYGChATgrA", "wPmA9tJ9etsGbN356jTNkETcEoLyc9VpJN32WlqxNda4UKIFKQ");

	$object->authorizeToken();
	my $error = $object->getError();
	if(not defined $error){
		my $token = $object->getToken();
		return ($token, undef);
	}
	return (undef, $error);
}

get '/tweets/:name' => sub{
	my $user = params->{name};
	my ($token, $error) = generateToken();
	if(not defined $error){
		my $object = new Twitterfry($token,[$user],10);
		$object->getTweets();
		$error = $object->getError();
		if(not defined $error){
			my $result = $object->getResult();
			return "$result\n";
		}else{
			return "$error\n";
		}
	}else{
		return "$error\n";
	}
};

get '/followings/:person1/:person2' => sub{
	my $person1 = params->{person1};
	my $person2 = params->{person2};
	
	my ($token, $error) = generateToken();
	if(not defined $error){
		my $object = new Twitterfry($token,[$person1,$person2],20);
		$object->getCommonFollowings();
		$error = $object->getError();
		if(not defined $error){
			my $result = $object->getResult();
			return "$result\n";
		}else{
			return "$error\n";
		}
	}else{
		return "$error\n";
	}	
};

dance;
