# sfw/bash/url-shooter/funcs/run-url-shooter.func.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doRunUrlShooter comments ...
# ---------------------------------------------------------
doRunUrlShooter(){

	doLog "DEBUG START doRunUrlShooter"
	
	cat docs/txt/url-shooter/funcs/perl/run-url-shooter.func.txt
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 

	# Action ... !!!
	perl sfw/perl/url_shooter/script/url_shooter.pl \
			--md-file `pwd`/data/md/isg_pub_en.Maintenance.2.README.md

	doLog "DEBUG STOP  doRunUrlShooter"
}
# eof func doRunUrlShooter


# eof file: sfw/bash/url-shooter/funcs/run-url-shooter.func.sh
