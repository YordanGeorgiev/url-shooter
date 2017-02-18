#!/usr/bin/env perl

use strict;
use warnings;

   $|++;


require Exporter ;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw() ;
our $AUTOLOAD =();

use Data::Printer ; 
use URI::Encode qw(uri_encode uri_decode);
use JSON ();
use JSON::Parse ':all' ;
use WWW::Curl;
use HTTP::Response ; 
use WWW::Curl::Easy;

use utf8 ;
use Carp ;
use Cwd qw ( abs_path ) ;
use Getopt::Long;

my $objConfigurator ; 
my $objLogger ; 
my $appConfig ; 
my $objInitiator ; 
my $TOKEN ; 
my $PROJECT_ID ; 



BEGIN {
	use Cwd qw (abs_path) ;
	my $my_inc_path = Cwd::abs_path( $0 );

	$my_inc_path =~ m/^(.*)(\\|\/)(.*?)(\\|\/)(.*)/;
	$my_inc_path = $1;
	
	# debug ok print "\$my_inc_path $my_inc_path \n" ; 

	unless (grep {$_ eq "$my_inc_path"} @INC) {
		push ( @INC , "$my_inc_path" );
		$ENV{'PERL5LIB'} .= "$my_inc_path" ;
	}

	unless (grep {$_ eq "$my_inc_path/lib" } @INC) {
		push ( @INC , "$my_inc_path/lib" );
		$ENV{'PERL5LIB'} .= ":$my_inc_path/lib" ;
	}
}

# use own modules ...
use UrlShooter::App::Utils::Initiator ; 
use UrlShooter::App::Utils::Configurator ; 
use UrlShooter::App::Utils::Logger ; 
use UrlShooter::App::Utils::ETL::UrlShooter ; 
use UrlShooter::App::Utils::IO::FileHandler ; 
use UrlShooter::App::Utils::ETL::UrlShooter ; 
use UrlShooter::App::Model::DbHandlerFactory ; 
use UrlShooter::App::Model::MariaDbHandler ; 

my $md_file 							= '' ; 
my $rdbms_type 						= 'mariadb' ; #todo: parametrize to 

#
# the main entry point of the application
#
sub main {

	print " url_shooter.pl START MAIN \n " ; 
    doInitialize();	
	
	my $objUrlShooter 				= 'UrlShooter::App::Utils::ETL::UrlShooter'->new ( \$appConfig ) ; 
	#my ( $hash_meta , $hash_data ) 	= $objUrlShooter->doConvertMdFileToBigSqlHash ( $md_file ) ; 

	#my $objDbHandlerFactory = 'UrlShooter::App::Model::DbHandlerFactory'->new( \$appConfig );
	#my $objDbHandler 			= $objDbHandlerFactory->doInstantiate ( "$rdbms_type" );

	# $objDbHandler->doInsertSqlHashData ( $hash_meta , $hash_data ) ;
    
    #doGetWhoAmI() ;  
    doGetListOfStories();

    
   
	$objLogger->doLogInfoMsg ( "STOP  MAIN") ; 
}
#eof sub main



sub doGetWhoAmIOld {
    
    print ( "TOKEN : " . $TOKEN ) ; 
    # get the who am I response 
    my $cmd='curl -X GET -H "X-TrackerToken: ' . "$TOKEN" . '" "https://www.pivotaltracker.com/services/v5/me?fields=%3Adefault"' ; 

    my $json_str = `$cmd`;  
    p($json_str); 

    my $json_data = JSON->new->utf8->decode($json_str);
    p($json_data);

}
#eof sub


sub doGetListOfStories {

    my $TOKEN = $ENV{'PIVOTAL_API_TOKEN'} ;  
    my $PROJECT_ID = $appConfig->{'PROJECT_ID'} ; 
    my $url = 'https://www.pivotaltracker.com/services/v5/projects/' . "$PROJECT_ID" . '/stories/' ; 
    my $curl = WWW::Curl::Easy->new;


    $curl->setopt(WWW::Curl::Easy::CURLOPT_HEADER(),1);
    $curl->setopt(WWW::Curl::Easy::CURLOPT_URL() , $url );
    $curl->setopt(WWW::Curl::Easy::CURLOPT_HTTPHEADER() , ['X-TrackerToken: ' . $TOKEN]  );

    my $msg = "WORKIG ON THE FOLLOWING PROJECT_ID: " . $PROJECT_ID ; 
    $objLogger->doLogInfoMsg ( $msg ) ; 

    # A filehandle, reference to a scalar or reference to a typeglob can be used here.
    my $response_body;
    $curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEDATA(),\$response_body);
    
    # Starts the actual request
    my $ret = $curl->perform;

    if ($ret == 0) {
        
        $objLogger->doLogInfoMsg ( "Transfer went ok" ) ; 
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        # judge result and next action based on $response_code

        $response_body = HTTP::Response->parse($response_body);
        # print("Received response: \n");
        # p($response_body);

        my $json_str = $response_body->content ; 
        # print("json_str: \n");
        # p($json_str);

        my $json_data = JSON->new->utf8->decode($json_str);
        print("json_data \n");
        p($json_data);


       my @arr_stories = @$json_data ;    
       foreach my $hsh_story ( @arr_stories ) {

           $msg = 'story name: ' . $hsh_story->{'name'} ; 
           doGetAStory($hsh_story ) ; 
           $objLogger->doLogInfoMsg ( $msg ) ; 
       }
       # eof foreach hsh_story
    } else {
       # Error code, type of error, error message
        print("An error happened: $ret ".$curl->strerror($ret)." ".$curl->errbuf."\n");
    }
    # get the project stories
    

}
#eof sub 


sub doGetAStory {
   my $hsh_story = shift ; 
   my $TOKEN = $ENV{'PIVOTAL_API_TOKEN'} ;  
   my $PROJECT_ID = $appConfig->{'PROJECT_ID'} ; 

   my $story_id = $hsh_story->{'id'} ; 
   my $url='https://www.pivotaltracker.com/services/v5/projects/' . $PROJECT_ID . '/stories/' . $story_id ;

    my $curl = WWW::Curl::Easy->new;


    $curl->setopt(WWW::Curl::Easy::CURLOPT_HEADER(),1);
    $curl->setopt(WWW::Curl::Easy::CURLOPT_URL() , $url );
    $curl->setopt(WWW::Curl::Easy::CURLOPT_HTTPHEADER() , ['X-TrackerToken: ' . $TOKEN]  );

    my $msg = "WORKIG ON THE FOLLOWING PROJECT_ID: " . $PROJECT_ID ; 
    $objLogger->doLogInfoMsg ( $msg ) ; 

    # A filehandle, reference to a scalar or reference to a typeglob can be used here.
    my $response_body;
    $curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEDATA(),\$response_body);
    
    # Starts the actual request
    my $ret = $curl->perform;

    if ($ret == 0) {
        
        print("Transfer went ok\n");
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        # judge result and next action based on $response_code

        $response_body = HTTP::Response->parse($response_body);
        #print("Received response: \n");
        #p($response_body);

        my $json_str = $response_body->content ; 
        # print("json_str: \n");
        # p($json_str);

        my $json_data = JSON->new->utf8->decode($json_str);
        # print("json_data \n");
        p($json_data);

    } else {
       # Error code, type of error, error message
        print("An error happened: $ret ".$curl->strerror($ret)." ".$curl->errbuf."\n");
    }
    # get the project stories

}
#eof sub 



sub doInitialize {

    $TOKEN = $ENV{'PIVOTAL_API_TOKEN'} ;  
    $PROJECT_ID = $appConfig->{'PROJECT_ID'} ; 

	$objInitiator 		= 'UrlShooter::App::Utils::Initiator'->new();
	$appConfig 			= $objInitiator->get('AppConfig') ; 
	p ( $appConfig  ) ; 
	$objConfigurator 	= 
	'UrlShooter::App::Utils::Configurator'->new( $objInitiator->{'ConfFile'} , \$appConfig ) ; 
	$objLogger 			= 'UrlShooter::App::Utils::Logger'->new( \$appConfig ) ;
		
	$objLogger->doLogInfoMsg ( "START MAIN") ; 
	$objLogger->doLogInfoMsg ( "START LOGGING SETTINGS ") ; 
	p ( $appConfig  ) ; 
	$objLogger->doLogInfoMsg ( "STOP  LOGGING SETTINGS ") ; 

		GetOptions(	
			   "md-file:s"			=>\$md_file
			 , "rdbms_type"		=>\$rdbms_type
		);
}
#eof doInitialize



# Action !!!
main () ; 

