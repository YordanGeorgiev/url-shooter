package UrlShooter::App::Ctrl::CtrlURLRun ; 

	use strict; use warnings;

	my $VERSION = '1.0.0';    #docs at the end

	require Exporter;
	our @ISA = qw(Exporter);
	our $AUTOLOAD =();
	our $ModuleDebug = 0 ; 
	use AutoLoader;

	use Cwd qw/abs_path/;
	use File::Path qw(make_path) ;
   use WWW::Curl::Easy ; 
	use Data::Printer ; 
   use HTTP::Response ; 
	use File::Find ; 
	use Sys::Hostname;
	use Carp qw /cluck confess shortmess croak carp/ ; 

	use UrlShooter::App::Utils::IO::FileHandler ; 
	use UrlShooter::App::Utils::Logger ;
   use UrlShooter::App::Data::UrlRunner ; 
	
	our $appConfig						= {} ; 
	our $RunDir 						= '' ; 
	our $ProductBaseDir 				= '' ; 
	our $ProductDir 					= '' ; 
	our $ProductInstanceDir 			= ''; 
	our $EnvironmentName 			= '' ; 
	our $ProductName 					= '' ; 
	our $ProductType 					= '' ; 
	our $ProductVersion 				= ''; 
	our $ProductOwner 				= '' ; 
	our $HostName 						= '' ; 
	our $ConfFile 						= '' ; 
	our $objLogger						= {} ; 

=head1 SYNOPSIS

my ( $ret , $response_code , $response_body , $response_content )  = () ; 
( $ret , $response_code , $response_body , $response_content ) 
      = $objUrlShooter->doRunURL( $http_method , $url );

=cut 

=head1 EXPORT

	A list of functions that can be exported.  You can delete this section
	if you don't export anything, such as for a purely object-oriented module.
=cut 

=head1 SUBROUTINES/METHODS

	# -----------------------------------------------------------------------------
	START SUBS 
=cut

# 
# performs an http request 	
#
sub doRunURLs {
   # read the list of urls 
   my $self = shift ; 
   my $msg        = 'START URL run' ; 
   $objLogger->doLogInfoMsg ( $msg ) ; 


   my $hsrUrls = {
         1 => 'www.google.fi'
      ,  2 => 'www.webopedia.com'

   };
   use Test::More  ; 

   # -- foreach url do run it
   foreach my $url_id ( sort ( keys %$hsrUrls ) ) {

      my $objUrlShooter = 'UrlShooter::App::Data::UrlRunner'->new( \$appConfig ) ; 
      my $url           = $hsrUrls->{ "$url_id" } ; 
      my $http_method   = 'GET' ; 
      my $got           = undef ; 
      my $expected      = 200 ; 
      my $test_name     = "testing that the ret from the call is $expected to the url: $url" ; 

      my ( $ret , $response_code , $response_body , $response_content )  = () ; 
      ( $ret , $response_code , $response_body , $response_content ) 
            = $objUrlShooter->doRunURL( $http_method , $url );

( $ret , $response_code , $response_body , $response_content ) 
      = $objUrlShooter->doRunURL( $http_method , $url );

      $got = $response_code ; 
      cmp_ok($got, '==', $expected, $test_name);


   }
   done_testing(); 

   $msg        = 'STOP  URL run' ; 
   $objLogger->doLogInfoMsg ( $msg ) ; 
}
#eof sub doRunURLs



	#
	# --------------------------------------------------------
	# intializes this object 
	# --------------------------------------------------------
	sub doInitialize {
	   my $self       = shift ; 	
		$appConfig  = ${ shift @_ } if ( @_ );

		$objLogger 	= "UrlShooter::App::Utils::Logger"->new( \$appConfig ) ; 
	}	
	#eof sub doInitialize
	

=head1 WIP

	
=cut

=head1 SUBROUTINES/METHODS

	STOP  SUBS 
	# -----------------------------------------------------------------------------
=cut


=head2 new
	# -----------------------------------------------------------------------------
	# the constructor
=cut 

	# -----------------------------------------------------------------------------
	# the constructor 
	# -----------------------------------------------------------------------------
	sub new {
      my $class            = shift ;    # Class name is in the first parameter
		$appConfig = ${ shift @_ } if ( @_ );

      # Anonymous hash reference holds instance attributes
      my $self = { }; 
      bless($self, $class);     # Say: $self is a $class

      $self->doInitialize( \$appConfig ) ; 
      return $self;
		
	}  
	#eof const

=head2
	# -----------------------------------------------------------------------------
	# overrided autoloader prints - a run-time error - perldoc AutoLoader
	# -----------------------------------------------------------------------------
=cut
	sub AUTOLOAD {

		my $self = shift;
		no strict 'refs';
		my $name = our $AUTOLOAD;
		*$AUTOLOAD = sub {
			my $msg =
			  "BOOM! BOOM! BOOM! \n RunTime Error !!! \n Undefined Function $name(@_) \n ";
			croak "$self , $msg $!";
		};
		goto &$AUTOLOAD;    # Restart the new routine.
	}   
	# eof sub AUTOLOAD


	# -----------------------------------------------------------------------------
	# return a field's value
	# -----------------------------------------------------------------------------
	sub get {

		my $self = shift;
		my $name = shift;
		croak "\@UrlShooter.pm sub get TRYING to get undefined name" unless $name ;  
		croak "\@UrlShooter.pm sub get TRYING to get undefined value" unless ( $self->{"$name"} ) ; 

		return $self->{ $name };
	}    #eof sub get


	# -----------------------------------------------------------------------------
	# set a field's value
	# -----------------------------------------------------------------------------
	sub set {

		my $self  = shift;
		my $name  = shift;
		my $value = shift;
		$self->{ "$name" } = $value;
	}
	# eof sub set


	# -----------------------------------------------------------------------------
	# return the fields of this obj instance
	# -----------------------------------------------------------------------------
	sub dumpFields {
		my $self      = shift;
		my $strFields = ();
		foreach my $key ( keys %$self ) {
			$strFields .= " $key = $self->{$key} \n ";
		}

		return $strFields;
	}    
	# eof sub dumpFields
		

	# -----------------------------------------------------------------------------
	# wrap any logic here on clean up for this class
	# -----------------------------------------------------------------------------
	sub RunBeforeExit {

		my $self = shift;

		#debug print "%$self RunBeforeExit ! \n";
	}
	#eof sub RunBeforeExit


	# -----------------------------------------------------------------------------
	# called automatically by perl's garbage collector use to know when
	# -----------------------------------------------------------------------------
	sub DESTROY {
		my $self = shift;

		#debug print "the DESTRUCTOR is called  \n" ;
		$self->RunBeforeExit();
		return;
	}   
	#eof sub DESTROY


	# STOP functions
	# =============================================================================

	


1;

__END__

=head1 NAME

UrlShooter 

=head1 SYNOPSIS

use UrlShooter  ; 


=head1 DESCRIPTION
the main purpose is to initiate minimum needed environment for the operation 
of the whole application - man app config hash 

=head2 EXPORT


=head1 SEE ALSO

perldoc perlvars

No mailing list for this module


=head1 AUTHOR

yordan.georgiev@gmail.com

=head1 




# ---------------------------------------------------------
# VersionHistory: 
# ---------------------------------------------------------
#
1.2.0 --- 2014-09-11 20:44:26 -- tests on Windows 
1.1.0 --- 2014-08-27 11:29:25 -- tests passed with Test::More
1.0.0 --- 2014-08-25 08:25:15 -- refactored away from main calling script

=cut 

