use strict ; use warnings ; 

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use Test::More tests => 2 ; 
use Data::Printer ; 

use UrlShooter::App::Utils::Initiator ; 
use UrlShooter::App::Utils::ETL::JSONHandler ; 


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

my $objJSONHandler = 'UrlShooter::App::Utils::ETL::JSONHandler' ->new( \$appConfig ) ; 
   my ( $ret , $urls )     = () ; 

my $json_file              = "$ProductInstanceDir/data/json/example.postman_collection.json" ; 

( $ret , $urls) =  $objJSONHandler->doReadJSONFile( $json_file ) ; 

p($urls);

$expected                  = 'google.com' ; 
$test_name                 = "the name of the first item is $expected" ; 
$got                       = $urls->{'item'}[0]->{'name'} ; 
cmp_ok($got, 'eq', $expected, $test_name);

$expected                  = 'webopedia' ; 
$test_name                 = "the name of the first item is $expected" ; 
$got                       = $urls->{'item'}[1]->{'name'} ; 
cmp_ok($got, 'eq', $expected, $test_name);

