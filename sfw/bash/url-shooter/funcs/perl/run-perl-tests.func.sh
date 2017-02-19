# sfw/bash/url-shooter/funcs/run-perl-tests.func.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doRunPerlTests comments ...
# ---------------------------------------------------------
doRunPerlTests(){
	
   cd $product_instance_dir
	doLog "INFO START : doRunPerlTests"

	doLog "INFO START Component testing TestInitiator.t"
	#perl sfw/perl/url_shooter/t/TestInitiator.t
	doLog "INFO STOP  Component testing TestInitiator.t"
	test -z "$sleep_iterval" || sleep $sleep_iterval

	doLog "INFO START Component testing TestUrlRunner.t"
   perl sfw/perl/url_shooter/t/TestUrlRunner.t
	doLog "INFO STOP  Component testing TestUrlRunner.t"
	test -z "$sleep_iterval" || sleep $sleep_iterval

	
	#doLog "INFO Component testing  with TestLogger "
	#perl sfw/perl/url_shooter/t/TestLogger.pl
	#test -z "$sleep_iterval" || sleep $sleep_iterval
	
	doLog "INFO STOP  : doRunPerlTests"
}
# eof func doRunPerlTests


# eof file: sfw/bash/url-shooter/funcs/run-perl-tests.func.sh
