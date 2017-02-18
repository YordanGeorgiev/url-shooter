# sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.spec.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doSpecCheckPerlModulesPrerequisites comments ...
# ---------------------------------------------------------
doSpecCheckPerlModulesPrerequisites(){

	doLog "DEBUG START doSpecCheckPerlModulesPrerequisites"
	
	cat docs/txt/wrapp/specs/check-perl-modules-prerequisites.spec.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!

	doLog "DEBUG STOP  doSpecCheckPerlModulesPrerequisites"
}
# eof func doSpecCheckPerlModulesPrerequisites


# eof file: sfw/bash/wrapp/funcs/check-perl-modules-prerequisites.spec.sh
