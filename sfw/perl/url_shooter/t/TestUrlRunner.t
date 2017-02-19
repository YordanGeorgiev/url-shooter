use strict ; use warnings ; 

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use UrlShooter::App::Utils::Initiator ; 
use UrlShooter::App::Data::UrlRunner ; 
use Test::More tests => 2 ; 
use Data::Printer ; 

my $test_name              = q{} ; 
my $got                    = q{} ; 
my $expected               = q{} ; 
my $url                    = q{} ; 
my $http_method            = q{} ; 
my $objInitiator 				= 'UrlShooter::App::Utils::Initiator'->new();	
my $appConfig					= {} ;
my $ProductBaseDir 			= $objInitiator->doResolveMyProductBaseDir();
my $ProductDir 				= $objInitiator->doResolveMyProductDir();
my $ProductInstanceDir 		= $objInitiator->doResolveMyProductInstanceDir();
my $EnvironmentName 			= $objInitiator->doResolveMyEnvironmentName();
my $ProductName 				= $objInitiator->doResolveMyProductName();
my $ProductVersion 			= $objInitiator->doResolveMyProductVersion();
my $ProductType 				= $objInitiator->doResolveMyProductType();
my $ProductOwner 				= $objInitiator->doResolveMyProductOwner();
my $ConfFile 					= $objInitiator->doResolveMyConfFile();
my $HostName					= $objInitiator->doResolveMyHostName();

$appConfig						= $objInitiator->get ('AppConfig'); 
# p($appConfig) ; 

my $objUrlShooter = 'UrlShooter::App::Data::UrlRunner'->new( \$appConfig ) ; 

$url           = 'https://www.google.fi' ; 
$expected      = 0 ; 
$http_method   = 'GET' ; 
$test_name     = "testing that the ret from the call is $expected to the url: $url" ; 

my ( $ret , $response_code , $response_body , $response_content )  = () ; 
( $ret , $response_code , $response_body , $response_content ) 
      = $objUrlShooter->doRunURL( $http_method , $url );

$got = $ret ; 
cmp_ok($got, '==', $expected, $test_name);


$http_method   = 'GET' ; 
$url           = 'http://www.webopedia.com' ; 
$expected      = 200 ; 
$test_name     = "testing that the ret from the call is $expected to the url: $url" ; 
( $ret , $response_code , $response_body , $response_content ) 
      = $objUrlShooter->doRunURL( $http_method , $url );

$got = $response_code ; 
cmp_ok($got, '==', $expected, $test_name);

