# sfw/bash/url-shooter/funcs/run-url-shooter.test.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doTestRunUrlShooter comments ...
# ---------------------------------------------------------
doTestRunUrlShooter(){

	doLog "DEBUG START doTestRunUrlShooter"
	
	cat docs/txt/url-shooter/tests/perl/run-url-shooter.test.txt
	test -z "$sleep_interval" || sleep "$sleep_interval"

	# Action !!!	
	bash sfw/bash/url-shooter/url-shooter.sh -a run-url-shooter

	doLog "DEBUG STOP  doTestRunUrlShooter"

}
# eof func doTestRunUrlShooter


# eof file: sfw/bash/url-shooter/funcs/run-url-shooter.test.sh
