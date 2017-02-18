package UrlShooter::App::Utils::ETL::UrlShooter ; 

	use strict; use warnings;

	my $VERSION = '1.2.0';    #docs at the end

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
	# --------------------------------------------------------
	# reads an md file into hashref of hashrefs ...
	# --------------------------------------------------------
	sub doReadMdFileToHashRefs {

		my $self 				= shift ; 
		my $md_file 			= shift ; 

		my $objFileHandler 	= "UrlShooter::App::Utils::IO::FileHandler"->new( \$appConfig ) ; 
		my $objLogger 			= "UrlShooter::App::Utils::Logger"->new( \$appConfig ) ; 

		my $str_md_file		= $objFileHandler->ReadFileReturnString ( $md_file ) ; 
		my $big_hash			= {} ; 
		
		# debug ok $objLogger->doLogDebugMsg ( "str_md_file :" ) ; 
		# debug ok $objLogger->doLogDebugMsg ( $str_md_file ) ; 
		my $big_hash_meta			= {} ; 
		$big_hash_meta->{ 1 }  	= 'TableId' ; 
		$big_hash_meta->{ 2 }  	= 'SeqId' ; 
		$big_hash_meta->{ 3 }  	= 'Name' ; 
		$big_hash_meta->{ 4 }  	= 'Description' ; 
		$big_hash_meta->{ 5 }  	= 'SrcCode' ; 

		# my @chunks 				= split /\n[#]{1,6}\s+/ , $str_md_file ; 
		my $seq_id				= 1 ; 
		my $row_id				= 0 ; 

		foreach my $chunk ( split /\n[#]{1,6}\s+/ , $str_md_file ) {

			my $row_hash		= {} ;			# will correspond to the table row  
	
			$row_hash->{ 'Name' } = ( split /\n/, $chunk )[0] ; 
			$row_hash->{ 'Name' }=~ s/&lt;/</g ; 
			$row_hash->{ 'Name' }=~ s/&gt;/>/g ; 
			$row_hash->{ 'Name' }=~ s/^#*\s*//g ; # remove the initial #'s
			# remove the logical numbers 
			$row_hash->{ 'Name' }=~ s/^((\d){1}([\.]){0,1}){1,10}\s+//g ; 

			# remove the title
			$chunk 				=~ s/^(?:.*\n){1}//;

			# debug ok $objLogger->doLogDebugMsg ( "start chunk" ) ;
			# debug ok $objLogger->doLogDebugMsg ( "chunk is $chunk " ) ;
			# debug ok $objLogger->doLogDebugMsg ( "stop chunk" ) ;
			
			my @chunk_lines = split /\n/ , $chunk ; 

			$row_hash->{ 'SrcCode' } = " " ; 
			$row_hash->{ 'Description' } = " " ; 

			foreach my $line ( @chunk_lines ) {

				if ( $line =~ m/^(\s){4}/g ) {
					$line 			=~ s/^\s{4}//g ; 
					$row_hash->{ 'SrcCode' } .= $line . "\n" ; 
				} 
				else {
					$line =~ s/&lt;/</g ; 
					$line =~ s/&gt;/>/g ; 
					$row_hash->{ 'Description' } .= $line . "\n" ; 
				}
			}			

			$row_hash->{ 'SrcCode' } 		=~ s/\n\n/\n/mg ; 
			$row_hash->{ 'Description' } 	=~ s/\n\n//mg ; 

			$row_hash->{ 'SeqId' } 			= $seq_id ; 
			$row_hash->{ 'TableId' } 		= $row_id ; 
			$big_hash->{ $seq_id } 			= $row_hash ; 

			$seq_id++ ; 
			$row_id++ ; 
		} 
		#eof foreach $chunk
		
		# debug ok $self->doPrintDebugTheBigHash ( $big_hash_meta , $big_hash ) ; 
		return ( $big_hash_meta , $big_hash ) ; 
	}
	# eof sub doReadMdFileToHashRefs


	# 	
	# --------------------------------------------------------
	# spare the eyes of the Developer ... and print the struct
	# as it is logically displayed ..
	# --------------------------------------------------------
	sub doPrintDebugTheBigHash {

		my $self 				= shift ; 
		my $big_hash_meta 	= shift ; 
		my $big_hash 			= shift ; 
		
		foreach my $key ( sort { $a <=> $b } ( keys  %$big_hash ) ) {

			foreach my $k ( sort { $a <=> $b } ( keys %$big_hash_meta ) ) {

				print " \"" . $big_hash_meta-> { $k } . "\" ::: " ; 
				p (  $big_hash->{ $key }->{ $big_hash_meta-> { $k } } ) ; 
				print "\"\n" ; 
			}
		}	

	}
	#eof sub doPrintDebugTheBigHash


	
	# 	
	# --------------------------------------------------------
	# convert the already created big hash to insert statements
	# containing sql_big_hash
	# --------------------------------------------------------
	sub doConvertBigHashToSqlBigHash {

		my $self 				= shift ; 
		my $big_hash_meta 	= shift ; 
		my $big_hash 			= shift ; 
		
		foreach my $key ( sort { $a <=> $b } ( keys  %$big_hash ) ) {

			foreach my $k ( sort { $a <=> $b } ( keys %$big_hash_meta ) ) {

				print " \"" . $big_hash_meta-> { $k } . "\" ::: " ; 
				p (  $big_hash->{ $key }->{ $big_hash_meta-> { $k } } ) ; 
				print "\"\n" ; 
			}
		}	

	}
	#eof sub doConvertBigHashToSqlBigHash

	# 	
	# --------------------------------------------------------
	# parses the md file into hash ref of hash refs ... with specific keys and structure	
	# debugs the result 
	# converts the hash ref of hash refs into hash ref with runnable sql stmnts
	# --------------------------------------------------------
	sub doConvertMdFileToBigSqlHash {

		my $self 				= shift ; 
		my $md_file				= shift ; 
		
		my $big_hash_meta		= {} ;  # describes the structure of the big_hash_data
		my $big_hash_data		= {} ;  # contains the actual data of the md file but structured 
		my $big_hash_sql		= {} ;  # contains the data as runnable sql statements
		
		( $big_hash_meta , $big_hash_data ) = 
			$self->doReadMdFileToHashRefs ( $md_file ) ; 
		
		# debug ok $self->doPrintDebugTheBigHash ( $big_hash_meta , $big_hash_data )  ;

		( $big_hash_meta , $big_hash_sql ) = 
			$self->doConvertBigHashToSqlBigHash( $big_hash_meta , $big_hash_data )  ;
		
		return ( $big_hash_sql , $big_hash_meta ) ; 
	}
	# eof sub doConvertMdFileToBigSqlHash
	


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

