# sfw/bash/url-shooter/funcs/check-perl-syntax.help.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doHelpCheckPerlSyntax comments ...
# ---------------------------------------------------------
doHelpCheckPerlSyntax(){

	doLog "DEBUG START doHelpCheckPerlSyntax"
	
	cat docs/txt/url-shooter/helps/check-perl-syntax.help.txt
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 

	doLog "DEBUG STOP  doHelpCheckPerlSyntax"
}
# eof func doHelpCheckPerlSyntax


# eof file: sfw/bash/url-shooter/funcs/check-perl-syntax.help.sh
