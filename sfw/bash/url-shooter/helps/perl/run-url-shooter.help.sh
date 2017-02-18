# sfw/bash/url-shooter/funcs/run-url-shooter.help.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doHelpRunUrlShooter comments ...
# ---------------------------------------------------------
doHelpRunUrlShooter(){

	doLog "DEBUG START doHelpRunUrlShooter"
	
	cat docs/txt/url-shooter/helps/perl/run-url-shooter.help.txt
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 

	doLog "DEBUG STOP  doHelpRunUrlShooter"
}
# eof func doHelpRunUrlShooter


# eof file: sfw/bash/url-shooter/funcs/run-url-shooter.help.sh
