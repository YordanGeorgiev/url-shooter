package UrlShooter::App::Data::UrlRunner ; 

	use strict; use warnings;

	my $VERSION = '1.0.0';    #docs at the end

	require Exporter;
	our @ISA = qw(Exporter);
	our $AUTOLOAD =();
	our $ModuleDebug = 0 ; 
	use AutoLoader;


	use Cwd qw/abs_path/;
	use File::Path qw(make_path) ;
	use File::Find ; 
	use File::Copy;
	use File::Copy::Recursive ; 
	use Sys::Hostname;
	use Carp qw /cluck confess shortmess croak carp/ ; 
	use UrlShooter::App::Utils::IO::FileHandler ; 
	use UrlShooter::App::Utils::Logger ;
	use Data::Printer ; 
	
	our $appConfig						= {} ; 
	our $RunDir 						= '' ; 
	our $ProductBaseDir 				= '' ; 
	our $ProductDir 					= '' ; 
	our $ProductVersionDir 			= ''; 
	our $EnvironmentName 			= '' ; 
	our $ProductName 					= '' ; 
	our $ProductType 					= '' ; 
	our $ProductVersion 				= ''; 
	our $ProductOwner 				= '' ; 
	our $HostName 						= '' ; 
	our $ConfFile 						= '' ; 
	our $objLogger						= {} ; 

=head1 SYNOPSIS

	doResolves the product version and base dirs , bootstraps config files if needed

		use UrlShooter::App::Utils::ETL::UrlShooter ;
		my $objUrlShooter = 
			'UrlShooter::App::Utils::ETL::UrlShooter'->new ( \$appConfig ) ; 
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
sub doRunURL {

    my $self               = shift ; 
    my $http_method_type   = shift ; 
    my $url                = shift ;   
    my $headers            = shift ; 

    my $curl = WWW::Curl::Easy->new;
    $curl->setopt(WWW::Curl::Easy::CURLOPT_HEADER(),1);
    $curl->setopt(WWW::Curl::Easy::CURLOPT_URL(), "$url" );

    for my $key ( sort ( keys %$headers )) {
      my $header_name = $key ; 
      my $header_val = $headers->{ "$key" } ; 
      $curl->setopt(WWW::Curl::Easy::CURLOPT_HTTPHEADER() , [ $header_name . $header_val ]  );
    }


    if ( $http_method_type eq 'POST' ) {
      $curl->setopt(WWW::Curl::Easy::CURLOPT_POST(), 1);
    }

    # A filehandle, reference to a scalar or reference to a typeglob can be used here.
    my $response_body;
    $curl->setopt(WWW::Curl::Easy::CURLOPT_WRITEDATA(),\$response_body);
    
    # Starts the actual request
    my $ret = $curl->perform;


    if ($ret == 0) {
        
        print("Transfer went ok\n");
        my $response_code = $curl->getinfo('CURLINFO_HTTP_CODE');
        # judge result and next action based on $response_code

        my $json_str = HTTP::Response->parse($response_body);
        $response_body = HTTP::Response->parse($response_body);
        print("Received response: $response_body\n");
        #p($response_body);
        $json_str = $response_body->content ; 

        my $json_data = JSON->new->utf8->decode($json_str);
        p($json_data);

    } else {
       # Error code, type of error, error message
        print("An error happened: $ret ".$curl->strerror($ret)." ".$curl->errbuf."\n");
    }
   

}
#eof sub


	#
	# --------------------------------------------------------
	# intializes this object 
	# --------------------------------------------------------
	sub doInitialize {
		
		$objLogger 	= "UrlShooter::App::Utils::Logger"->new( \$appConfig ) ; 
	}	
	#eof sub doInitialize
	

=head1 WIP


	sub doShiftToRight {
		my $self 		= shift ; 
		my $refhsref 	= shift ; 
		my $hsref		= $$refhsref ; 
		my $cur_hsr		= shift ; 


		my $pLeftRank	= 1 ; 

		# get the point to the shift 
		foreach my $key ( sort ( keys ( $hsref ) ) ) {

			my $wip_hash = $hsref->{ $key } ; 

			# -- get the point to shift 
			# SELECT @pLeftRank := LeftRank from Item where ItemId = @pParentItemId ; 
			if ( ( $key - 1) == $cur_hsr->{ 'ParentItemId' } ) {

				$pLeftRank	= $hsref->{ ($key -1 ) }->{ 'LeftRank'} ; 
			}
		}
		#eof foreach key



		# shift the shiftable left ranks by two positions
		foreach my $key ( sort ( keys ( $hsref ) ) ) {

			my $wip_hash = $hsref->{ $key } ; 
			
			# UPDATE Item set RightRank = ( RightRank + 2 ) where RightRank > @pLeftRank; 
			if ( $wip_hash->{ 'RightRank' } > $pLeftRank ) {
				$wip_hash->{ 'RightRank' } = $wip_hash->{ 'RightRank' } + 2 ; 
				$hsref->{ $key } = $wip_hash ; 
			}


			# UPDATE Item set LeftRank = ( LeftRank + 2 ) where LeftRank > @pLeftRank; 
			if ( $wip_hash->{ 'LeftRank' } > $pLeftRank ) {
				$wip_hash->{ 'LeftRank' } = $wip_hash->{ 'LeftRank' } + 2 ; 
				$hsref->{ $key } = $wip_hash ; 
			}

		}
		#eof foreach key

		# INSERT into Item VALUES ( 1 , 1 , NULL , 1 , @pLeftRank+1 , @pLeftRank+2,'1.0.0' ) ;
		$hsref->{ $cur_hsr->{ 'SeqId' } }->{ 'LeftRank'} = $pLeftRank + 1 ; 
		$hsref->{ $cur_hsr->{ 'SeqId' } }->{ 'RightRank'} = $pLeftRank + 2 ; 



	}
	#eof sub doShiftToRight {
	
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
		
		my $invocant = shift;    
		# might be class or object, but in both cases invocant
		my $class = ref ( $invocant ) || $invocant ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class


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

