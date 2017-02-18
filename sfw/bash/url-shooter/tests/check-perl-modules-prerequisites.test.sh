# sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.test.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doTestCheckPerlModulesPrerequisites comments ...
# ---------------------------------------------------------
doTestCheckPerlModulesPrerequisites(){

	doLog "DEBUG START doTestCheckPerlModulesPrerequisites"
	
	cat docs/txt/wrapp/tests/check-perl-modules-prerequisites.test.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!
   bash sfw/bash/url-shooter/url-shooter.sh -a check-perl-modules-prerequisites

	doLog "DEBUG STOP  doTestCheckPerlModulesPrerequisites"
}
# eof func doTestCheckPerlModulesPrerequisites


# eof file: sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.test.sh
