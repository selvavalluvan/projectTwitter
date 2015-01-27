use Test::More tests => 2;
use strict;
use warnings;

# the order is important
use myheroku;
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';
route_exists [GET => '/tweets/SelvaValluvan'], 'a route handler is defined for /';
response_status_is ['GET' => '/tweets/SelvaValluvan'], 200, 'response status is 200 for /';
route_exists [GET => '/followings/SelvaValluvan/sarahhamm_'], 'a route handler is defined for /';
response_status_is ['GET' => '/followings/SelvaValluvan/sarahhamm_'], 200, 'response status is 200 for /';
