#!perl -T
use strict;
use warnings;
use Test::More;
use WebService::HMRC::Request;

plan tests => 12;

my $uri;
my $ws;


# Instatiate the basic object using defaults
$ws = WebService::HMRC::Request->new();
isa_ok($ws, 'WebService::HMRC::Request', 'WebService::HMRC::Request object created using defaults');
isa_ok($ws->ua, 'LWP::UserAgent', 'ua method returns LWP::UserAgent object');
is($ws->api_version, '1.0', 'api_version property is set to default');
is($ws->base_url, 'https://test-api.service.hmrc.gov.uk/', 'base_url method is set to default');
is($ws->ua->default_header('Accept'), 'application/vnd.hmrc.1.0+json', 'default Accept header set correctly');
$uri = $ws->endpoint_url('/test/endpoint');
isa_ok($uri, 'URI', 'endpoint_url method returns a URI object');
is($uri, 'https://test-api.service.hmrc.gov.uk/test/endpoint', 'endpoint_url correctly joins default base_url with endpoint');


# Instantiate object with specified parameters
$ws = WebService::HMRC::Request->new(
    base_url => 'https://example.com/ws/',
    api_version => '9.9',
);
isa_ok($ws, 'WebService::HMRC::Request', 'WebService::HMRC::Request object created using specified parameters');
is($ws->api_version, '9.9', 'api_version property is set to specified value');
is($ws->base_url, 'https://example.com/ws/', 'base_url method is set to specified value');
is($ws->ua->default_header('Accept'), 'application/vnd.hmrc.9.9+json', 'default Accept header uses specified api version');
$uri = $ws->endpoint_url('/test/endpoint');#/test/endpoint');
is($uri, 'https://example.com/ws/test/endpoint', 'endpoint_url correctly joins specified base_url with endpoint');


