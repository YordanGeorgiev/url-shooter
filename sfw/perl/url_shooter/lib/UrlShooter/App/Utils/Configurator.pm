package UrlShooter::App::Utils::Configurator ; 

	use strict ;  use warnings ;  use diagnostics ; 

	my $VERSION='2.6.0' ; #docs at the end
	require Exporter;

	my @ISA = qw(AutoLoader Exporter);
	my @EXPORT = qw(getConfHolder clone);

	use AutoLoader ; 
	use Carp ; 
	use IO::File; 
	our $ModuleDebug 			= 0  ; 
	our $NowInUnitTest 		= 0  ; 
	our $ConfFile 				= '' ; 
	our $HostName 				= () ; 

	# -----------------------------------------------------------------------------
	# the default global configuration hash ref
	# -----------------------------------------------------------------------------
	our $confHolder = {

		# Whether or not to print messages to STDOUT and / or STDERR
		  PrintConsoleMsgs =>               1
		# Whether or not to pring INFO messages
		, PrintInfoMsgs =>                  1                             
		# Whether or not to pring WARNING messages
		, PrintWarningMsgs =>               1                             
		# Whether or not to pring ERROR messages
		, PrintErrorMsgs =>                 1                             
		# Whether or not to pring DEBUG messages
		, PrintDebugMsgs =>                 1
		# Whether or not to pring TRACE messages
		, PrintTraceMsgs =>                 1 
		# The logging directory 
		, LogDir => '%ProductInstanceDir%/data/log'
		# the environment name of this product instance 
		, EnvironmentName =>   	'%ProductName%.%ProductVersion%.%ProductType%.%ProductOwner%'
		# the default Log file
		, LogFile =>            '%LogDir%/%ProductName%.log'
		# the default chars separating the time from the txt
		, LogTimeToTextSeparator =>'---'
		# whether or not to log to a file
		, LogToFile =>          1
		# the time format of the logging 
		, TimeFormat =>         'YYYY.MM.DD - hh:mm:ss'
		# the time format of the logging 
		, DbType 	=>         'maria_db'
	  };  
	  

	#
	# -----------------------------------------------------------------------------
	# the constructor 
	# -----------------------------------------------------------------------------
	sub new {
		
		my $invocant 			= shift;    
		$ConfFile 				= shift ; 
		my $ref_conf_holder	= shift ; 
      my $conf_holder   	= ${$ref_conf_holder} ; 


		# might be class or object, but in both cases invocant
		my $class = ref ( $invocant ) || $invocant ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class

		$self->doOverWriteConfHolder ($conf_holder ) ; 
		$self->doReadConfFile( $ConfFile);

		# print "Configurator.pm::: \n" ; 
		# use Data::Printer ; 
		# p($confHolder) ; 
		# sleep 6 ; 

		$$ref_conf_holder = $confHolder ; 

		return $self ; 

	}   
	#eof const

	# -----------------------------------------------------------------------------
	# a constructor taking an ini file and exisiting configuration setting hash
	# -----------------------------------------------------------------------------
	sub clone 
	{
		my $invocant 			= shift;    
		$ConfFile 				= shift ; 
      my $conf_holder   	= shift ; 

		
		#debug print "\n Configurator.pm 89 \$ConfFile : $ConfFile \n" ; sleep 5 ; 
		# might be class or object, but in both cases invocant
		my $class = ref ( $invocant ) || $invocant ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class

		# interpolate the global conf holder
		$self->doOverWriteConfHolder ($conf_holder ) ; 

		# populate with new values from the passed ini file
		#debug print "from Configurator clone : ConfFile:: $ConfFile \n" ; sleep 3 ; 
		$self->doReadConfFile( $ConfFile);

		# OBS in cloning we do not modify the original global app configuration Holder
		## $$ref_conf_holder = $confHolder ; 

		return $self ; 
	}
	# eof const


	# -----------------------------------------------------------------------------
	# This function goes through the confHolder nameless hash, it searches for
	# strings that look like %NAMEOFPARAM%, and replaces it with the
	# possible value
	# -----------------------------------------------------------------------------
	sub doParametrize {

		my $self 	= shift ;
		my $key 		= shift ; 
		my $Value 	= shift ;

		my $old_key = $key ; 

		#print " before if \$Value is $Value \n" ; 

		# start the interpolation of %vars%
		if( $Value =~ m/\%([a-zA-Z_]*?)\%/ ) {
			my $temp = $Value ; 
			# debug ok print " AFTER 1 if \$Value is $Value \n"  ; 

			my ($prt1,$value,$prt2) = ();
			
			#strip the everyting not interpolatable
			$temp =~ m/(.*?)\%([a-zA-Z]*?)\%(.*)/;
			($prt1,$value,$prt2)=($1 , $2 , $3 ) ;

			# debug ok print " AFTER 2 \$value is $value \n"  ; 

			# replace any %HostName% with the running <<NameOfTheHost>>
			croak "undef $confHolder->{'HostName'} " unless  ( $confHolder->{'HostName'} );
			$Value =~ s/\%HostName\%/$confHolder->{'HostName'}/g ; 

			# ($prt1,$value,$prt2)=/(.+?)\%([a-zA-Z]*)\%(.*)/;

			my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = 
									$self->GetTimeUnits(); 

			$Value =~ s/\%YYYY\%/$year/g ; 
			$Value =~ s/\%MM\%/$mon/g ; 
			$Value =~ s/\%DD\%/$mday/g ; 
			$Value =~ s/\%hh\%/$hour/g ; 
			$Value =~ s/\%mm\%/$min/g ; 
			$Value =~ s/\%ss\%/$sec/g ; 


			#debug print " AFTER 2 \$prt1 IS $prt1 ,\$value IS $value,\$prt2 IS $prt2 \n"; 
			#v.1.2.8 --- ysg --- replace the env vars as well 
			if ( defined ($ENV{"$value"})) {
				$Value =~ s/\%$value\%/$ENV{"$value"}/gi;
				#"%-40s %-80s"
				##debug printf ("%20s %-30s %-100s " , 'EnvVarName = EnvVarValue' , "$value" , "$ENV{$value}") ; 
			}


			#debug print "BEFORE the confHolder key is " . "$key" . "\n" ; 
			# at this point of time the $confHolder->{"$key"} might not even exist
			
			unless ( defined ( $confHolder->{"$value"} ) ) {
				die "all configuration variables should be defined in the conf_file !!!" ; 
			}
			else {
				$Value =~  s/\%$value\%/$confHolder->{"$value"}/gi
			}

			$confHolder->{"$key"} = $Value  ;

			# debug ok print "AFTER the confHolder key is " . "$key" . "\n" ; 
			# debug ok print "AFTER the confHolder value is " . $confHolder->{"$key"} . "\n" ; 
		} 
		#eof if start the interpolation of %vars%
		
		#debug #debug print "AFTER 3  \$Value IS $Value \n " ; 

	  if( $Value =~ m/(.*?)\%([a-zA-Z]*)\%(.*)/g ) {
			#debug #debug print "LABEL 4  \$Value IS $Value \n " ; 
			$Value = $self->doParametrize($key , $Value );
		}
		else {
			#debug #debug print "LABEL 5  \$Value IS $Value \n "  ;
			my $die_msg = "the var: %" . "$key" ."% is not defined in the ini file: $ConfFile ";
			return $Value;
		}

	} 
	#eof sub doParametrize


	# -----------------------------------------------------------------------------
	# read the ini file line by line, set VarName= VarValue to the confHash
	# if #include key is found on the left read the file path on the right 
	# recursively 
	# -----------------------------------------------------------------------------
	sub doReadConfFile {
		
		my $self 			= shift ;
		my $conf_file 		= shift || $ConfFile ; 

		my $msg 				= '' ; 
		my $error_msg 		= '' ; 
		
		# if we do not have an ini file return with the default values 
		unless ( -f $conf_file ) { return 0 ; }

		# dump those only 
		if ( $NowInUnitTest == 1 ) {
			$msg = "CFPoint7  OK reading the ini file :" ; 
			print "[INFO ] $msg \n" ; 
			$msg = $conf_file ; 
			print "[INFO ] $msg \n" ; 
			$msg = "interporlate ini file vars into global app configuration holder hash ref " ; 
			print "[INFO ] $msg \n" ; 
		}

		eval {
			use autodie ; 
			my $error_msg = "[FATAL] Configurator::doReadConfFile cannot open file: $conf_file" ; 
			#my $conf_file_h = IO::File->new();
			
			#$conf_file='/var/csitea/isg-pub/isg-pub.0.9.5.dev.ysg/foo.txxt' ; 
			#open (my $conf_file_h ,'<' , $conf_file);
			#open ( conf_file ,'<' , $conf_file) or die "$error_msg" ; 
			# debug print "cofigurator conf_file is $conf_file \n" ; 
			my $encoding = ":encoding(UTF-8)" ; 
			open(my $conf_file_h , '<', $conf_file ) 
				or die " cannot find conf_file $conf_file !!!" ; 
			#while ( < conf_file > ) {
			# no spaces between the first < the file handle >
			while ( <$conf_file_h> ) {
				#debug print "configurator \$_ :: $_ \n" ; 
				#skip the comments
				next if m/^\s+#/g ; 


				if ($_ =~ /^[a-zA-Z=]/) {
					chomp ; 	
					my @tokens = split('=',$_);

					#the var is the left most token separated by =
					my $key = shift (@tokens ) ; 
					#debug print "key:$key " if ( $NowInUnitTest ) ; 
					#
					my $value = join ('=' , @tokens ) ; 
					#debug print "value is $value \n" ; 	
					
					$key=trim($key);
					$value = trim($value);
					
					# debug print "Configurator while \$value is $value \n" if ( $NowInUnitTest ) ; 
					$value = $self->doParametrize($key , $value ) ;

					# if we have include notation 
					if ( $key eq '#include' ) {
						#debug print "found include \n\n\n" if ( $NowInUnitTest ) ;  
						# if the include file does not exist or is not readable
						# return with error
						unless ( -r $value ) {
							die "ERROR: unexisting configuration file : $value \n " ; 
							return 1 ; 
						}
						$self->doReadConfFile ( $conf_file , $value ) 
					}
					else {
						# set the VarName = VarValue into the hash
						$confHolder->{"$key"} = $value;
				  
				  } #eof if include 
				} #eof if this is key=value line
			} #eof while read line 
			
			close( $conf_file_h );
			$error_msg = '' ; 

		};	
			
		return 0;
	} 
	#eof sub doReadConfFile

	#
	# -----------------------------------------------------------------------------
	# returns the configuration as a single string 
	# -----------------------------------------------------------------------------
	sub dumpIni {
			
			my $self = shift ; 
			my $str_dump = () ; 
			my $msg = () ; 
			$msg = "CFPoint8  OK    Dump the ready configuration hash for review \n"  ;      
			#debug print "[INFO ] $msg" ; 
			
			$str_dump .= "\n\n[INFO ] == START == Using the following env INI in perl :\n" ; 
			foreach my $key (sort(keys %$confHolder))       {

				$str_dump .=  "$key = $confHolder->{$key} \n";
			}
			$str_dump .= "\n[INFO ] == STOP  == Using the following env INI in perl \n\n\n" ; 
			return $str_dump ; 

	} #eof sub 

	#
	# -----------------------------------------------------------------------------
	# overwrite my hash
	# -----------------------------------------------------------------------------
	sub doOverWriteConfHolder {
			
			my $self = shift ; 
			my $passed_conf_holder = shift ; 
			
			#debug print $self->dumpIni();
			
			foreach my $key (sort(keys %$passed_conf_holder ))       {
				$confHolder->{"$key"} = $passed_conf_holder->{"$key"} ; 
				if ( $NowInUnitTest == 1 ) {
					#debug print "overwriting the key: $key with value : " . $confHolder->{"$key"} . "\n" ; 
					#debug print "with the the new key: $key with new value : " . $passed_conf_holder->{"$key"} . "\n" ; 
				}
			}
			

	} #eof sub 

	# -----------------------------------------------------------------------------
	# all the ini key - values are set to the %ENV hash  
	# -----------------------------------------------------------------------------
	sub SetAllIniVarsToEnvironmentVars {
			
			my $self = shift ; 
			my $msg = () ; 
			$msg = "set all ini vars to env vars"  ;        
			#debug print "$msg \n" if ( $NowInUnitTest ) ;  

			foreach my $key (sort(keys %$confHolder))       {
				$ENV{"$key"}=$confHolder->{"$key"} ; 
			} #eof foreach
	} 
	#eof sub SetAllIniVarsToEnvironmentVars


	# -----------------------------------------------------------------------------
	# returns the ini settings into a string 
	# -----------------------------------------------------------------------------
	sub DumpEnvVars {
			
			my $self = shift ; 
			my $str_dump = () ; 
			
			$str_dump .= "\n\n[INFO ] == START == Using the following env vars in perl :\n"  ;
			foreach my $key (sort(keys %ENV)) {
				$str_dump .=  "$key = $ENV{$key} \n";
			}
			$str_dump .= "\n[INFO ] == STOP  == Using the following env vars in perl\n\n\n" ; 
			return $str_dump ; 
	} 
	#eof sub DumpEnvVars


	# -----------------------------------------------------------------------------
	# get a value from the configuration hash by its name
	# -----------------------------------------------------------------------------
	sub get  {
			
			shift;
			my $name_l = shift;
			return $confHolder->{$name_l};
	}  
	# eof sub get 


	# -----------------------------------------------------------------------------
	# sets a value into the configuration hash 
	# -----------------------------------------------------------------------------
	sub set  {
			
			shift;
			my $name_l = shift;
			my $Value = shift;
			$confHolder->{$name_l}=$Value;
	} 
	#eof sub


	# -----------------------------------------------------------------------------
	#  Return the confHolder hash reference
	# -----------------------------------------------------------------------------
	sub getConfHolder {  

		return $confHolder ; 
	} 
	#eof sub getConfHolder


	# -----------------------------------------------------------------------------
	# used to trap and log run-time errors
	# -----------------------------------------------------------------------------
	sub AUTOLOAD {
		no strict 'refs'; 
		my $name = our $AUTOLOAD;
		*$AUTOLOAD = sub { 
			my $msg = '' ; 
			$msg .= "BOOM! BOOM! BOOM! \n RunTime Error !!!\n" ; 
			$msg .= "ERROR --- undefined function $name(@_) \n" ;
			#debug print $msg ; 
		};
		goto &$AUTOLOAD;    # Restart the new routine.
	} #eof sub  


	# -----------------------------------------------------------------------------
	# used to trap and log run-time errors
	# -----------------------------------------------------------------------------
	sub DESTROY {
		my $self = shift;
		#debug #debug print "the DESTRUCTOR is called  \n" ; 
		return ; 
	} 
	# eof sub 


	# -----------------------------------------------------------------------------
	# used to trap and log run-time errors
	# -----------------------------------------------------------------------------
	sub trim {

		 $_[0] =~ s/^\s+//;
		 $_[0] =~ s/\s+$//;
		 return $_[0];
	}
	# eof sub trim 


	# -----------------------------------------------------------------------------
	# my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = $self-> GetTimeUnits(); 
	# -----------------------------------------------------------------------------
	sub GetTimeUnits {

		my $self = shift ; 

		# Purpose returns the time in yyyymmdd-format 
		my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
		#---- change 'month'- and 'year'-values to correct format ---- 
		$sec = "0$sec" if ($sec < 10); 
		$min = "0$min" if ($min < 10); 
		$hour = "0$hour" if ($hour < 10);
		$mon = $mon + 1;
		$mon = "0$mon" if ($mon < 10); 
		$year = $year + 1900;
		$mday = "0$mday" if ($mday < 10); 

		return ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) ; 

	} #eof sub 

	#
	# -----------------------------------------------------------------------------
	#  Return the confHolder hash reference
	# -----------------------------------------------------------------------------
	sub getConfHolderRef {  

		return \$confHolder ; 
	} 
	#eof sub getConfHolder

1;

__END__



=head1 NAME

Configurator 

=head1 SYNOPSIS

use Configurator ; 
my $objConfigurator = new Configurator( $ConfFile , \$confholder ) ;
my $objConfigurator = clone Configurator($FileRobotsIni , \$confHolder); 

=head1 DESCRIPTION

This package is responsible for reading the ini-files
it is used by every other application and module in the Product
use vars qw(%variables);


=head2 EXPORT


=head1 SEE ALSO

perldoc perlvars

No mailing list for this module


=head1 AUTHOR

yordan.georgiev@gmail.com

=head1 COPYRIGHT LICENSE

Copyright (C) 2016 Yordan Georgiev

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.1 or,
at your option, any later version of Perl 5 you may have available.


#
# =========================================================
# 	-- VersionHistory -- 
# =========================================================
#
2.6.0 -- 2016-11-14 15:28:15 -- ysg -- fixed bug with non-interpolating
2.5.0 -- 2014-08-25 22:57:41 -- ysg -- refactoring, clean-up unneeded settings 
2.4.0 -- 2012-12-28 19:06:28 -- ysg -- added #include = <<file_path>>
2.3.0 -- 2012-12-26 14:35:48 -- ysg -- imporoved docs 
2.2.2 -- 2012-06-22 19:48:41 -- ysg -- Refactored var names 
2.2.1 -- ysg -- added if ( $NowInUnitTest ) ; 
2.2.0 -- ysg -- If key has Dir or File in its name, but not Command change / 's to \'s on Windows 
2.1.0 -- ysg -- Added the clone constructor - creating a clone configurator based on exising hash
2.0.1 -- ysg -- Improved dumping of environment and ini variables 
2.0.0 -- ysg -- SetAllIniVarsToEnvironmentVars
1.9.1 -- ysg -- Removed default vars, set by each module's Initialize,fixed constructor
1.8.1 -- ysg -- Added Control Flow doc 
1.8.0 -- ysg -- Added HostName interpolation with Sys::Hostname
1.7.0 -- ysg -- Added default value for MustRunCmdCommands
1.6.0 -- ysg -- Fixed bug with MM mm gi 
1.5.0 -- ysg -- Added BaseDir passing from caller in constructor
1.4.0 -- ysg -- Added YYYYMMDD hhmmss substitution interpolation
1.3.0 -- ysg -- Added default values for $confHolder according to latest 2.0.0 vars
1.2.8 -- ysg -- Added the "¤" , "." , "_" chars in the doReadConfFile for the vars part
1.0.0 -- ysg -- Added proper docs
0.9.0 -- ysg -- added Env vars interpolation
0.8.6 -- ysg -- added left most = in init
0.7.0 -- ysg -- Added run-time exception handling , full OO 
0.6.0 -- ysg -- Added DumpIni 
0.5.0 -- ysg -- Stolen shamelessly from SC 4.2

=cut
