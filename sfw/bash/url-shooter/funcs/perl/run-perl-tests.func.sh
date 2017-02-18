# sfw/bash/url-shooter/funcs/run-perl-tests.func.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doRunPerlTests comments ...
# ---------------------------------------------------------
doRunPerlTests(){
	
	doLog "DEBUG START : doRunPerlTests"

	doLog "INFO Component testing Initiator.pm with TestInitiator "
	perl sfw/perl/url_shooter/t/TestInitiator.pm
	test -z "$sleep_iterval" || sleep $sleep_iterval
	
	doLog "INFO Component testing Logger.pm with TestLogger "
	perl sfw/perl/url_shooter/t/TestLogger.pl
	test -z "$sleep_iterval" || sleep $sleep_iterval
	
	doLog "INFO STOP  : doRunPerlTests"
}
# eof func doRunPerlTests


# eof file: sfw/bash/url-shooter/funcs/run-perl-tests.func.sh
