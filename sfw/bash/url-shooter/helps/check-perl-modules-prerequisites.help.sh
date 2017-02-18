# sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.help.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doHelpCheckPerlModulesPrerequisites comments ...
# ---------------------------------------------------------
doHelpCheckPerlModulesPrerequisites(){

	doLog "DEBUG START doHelpCheckPerlModulesPrerequisites"
	
	cat docs/txt/wrapp/helps/check-perl-modules-prerequisites.help.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!

	doLog "DEBUG STOP  doHelpCheckPerlModulesPrerequisites"
}
# eof func doHelpCheckPerlModulesPrerequisites


# eof file: sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.help.sh
