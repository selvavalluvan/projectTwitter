#!/usr/bin/env perl
use Dancer;
use LWP::UserAgent;
use JSON qw( decode_json );
use Twitter;
use TwitterFry;

set public => path(dirname(__FILE__), '../public');

get '/' => sub{
      send_file '/index.html'
};


# My API Key and API ClientID.   If want to run your own app replace with your credentials.
sub generateToken {
      my $object = new Twitter( "Hrq0yQhYKSGsGKNaqMaHbOgEA", "9DK9tqvVhiTtPXGPIEYCWRkfOBbBRyODfnJfM3CqeMms4O8Nng");

      $object->authorizeToken();
      my $error = $object->getError();
      if(not defined $error){
            my $token = $object->getToken();
            return ($token, undef);
      }
      return (undef, $error);
};

get '/tweets/:name' => sub{
      my $user = params->{name};
      my ($token, $error) = generateToken();
      if(not defined $error){
            my $object = new TwitterFry($token,[$user],10);                      # Twitter gives back 20 recent tweets. This count is optional. If not provides, there is a predefined count at my twitter package.
            $object->getTweets();
            $error = $object->getError();
            if(not defined $error){
                  my $result = $object->getResult();
                  return "$result\n";
            }else{
                  status 422;                                                 #Unprocessable Entity.
                  return $error;
            }
      }else{
            status 422;
            return $error;
      }
};

get '/followings/:person1/:person2' => sub{
      my $person1 = params->{person1};
      my $person2 = params->{person2};

      my ($token, $error) = generateToken();
      if(not defined $error){
            my $object = new TwitterFry($token,[$person1,$person2],150);                    # The default count is 200 as Twitter RFC. If count is not assigned here, there is a count predefined at my twitter package.
            $object->getCommonFollowings();
            $error = $object->getError();
            if(not defined $error){
                  my $result = $object->getResult();
                  return "$result\n";
            }else{
                  status 422;
                  return "$error\n";
            }
      }else{
            status 422;
            return "$error\n";
      }
};

dance;
