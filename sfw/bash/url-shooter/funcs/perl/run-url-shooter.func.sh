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
   json_file="$product_instance_dir/data/json/example.postman_collection.json"
   doLog "passing as cmd arg the following json_file $json_file"

	perl sfw/perl/url_shooter/script/url_shooter.pl --json-file "$json_file"

	doLog "DEBUG STOP  doRunUrlShooter"
}
# eof func doRunUrlShooter


# eof file: sfw/bash/url-shooter/funcs/run-url-shooter.func.sh
