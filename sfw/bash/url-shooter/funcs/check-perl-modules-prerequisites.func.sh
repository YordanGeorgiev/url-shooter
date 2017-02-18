# sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.func.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doCheckPerlModulesPrerequisites comments ...
# ---------------------------------------------------------
doCheckPerlModulesPrerequisites(){

	doLog "DEBUG START doCheckPerlModulesPrerequisites"
	
	cat docs/txt/wrapp/funcs/check-perl-modules-prerequisites.func.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!
   perl sfw/perl/url_shooter/script/url_shooter_preq_checker.pl

	doLog "DEBUG STOP  doCheckPerlModulesPrerequisites"
}
# eof func doCheckPerlModulesPrerequisites


# eof file: sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.func.sh
