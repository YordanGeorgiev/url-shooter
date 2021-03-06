use strict ; use warnings ; 

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use UrlShooter::App::Utils::Initiator ; 
use Test::More tests => 20 ; 
use Data::Printer ; 


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
p($appConfig) ; 

ok ( $ProductBaseDir 		eq '/opt/csitea' ) ; 
ok ( $ProductDir 				eq '/opt/csitea/url-shooter' ) ; 
ok ( $ProductInstanceDir 	eq '/opt/csitea/url-shooter/url-shooter.0.2.6.tst.ysg' ); 
ok ( $ProductVersion 		eq '0.2.6' ); 
ok ( $EnvironmentName 		eq 'url-shooter.0.2.6.tst.ysg' ); 
ok ( $ProductType 			eq 'tst' ) ;
ok ( $ProductType 			ne 'dev' ) ;
ok ( $ProductType 			ne 'prd' ) ;
ok ( $ProductOwner 			eq 'ysg' ) ;
my $cmd_out						= `hostname -s` ; 
chomp ( $cmd_out ) ; 
ok ( $HostName 				eq "$cmd_out" ) ;
ok ( $ConfFile					eq 
'/opt/csitea/url-shooter/url-shooter.0.2.6.tst.ysg/conf/url-shooter.' . $cmd_out . '.conf' ) ; 

ok ( $ProductBaseDir 		eq $appConfig->{'ProductBaseDir'} ) ; 
ok ( $ProductDir 				eq $appConfig->{'ProductDir'} ) ; 
ok ( $ProductInstanceDir 	eq $appConfig->{'ProductInstanceDir'} ) ; 
ok ( $ProductVersion 		eq $appConfig->{'ProductVersion' } ); 
ok ( $EnvironmentName 		eq $appConfig->{'EnvironmentName'} ); 
ok ( $ProductType 			eq $appConfig->{'ProductType'} ) ;
ok ( $ProductOwner 			eq $appConfig->{'ProductOwner'} ) ;
ok ( $HostName 				eq $appConfig->{'HostName'} ) ;
ok ( $ConfFile 				eq $appConfig->{'ConfFile'} ) ;

