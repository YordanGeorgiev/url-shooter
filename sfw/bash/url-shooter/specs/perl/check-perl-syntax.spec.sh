# sfw/bash/url-shooter/funcs/check-perl-syntax.spec.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doSpecCheckPerlSyntax comments ...
# ---------------------------------------------------------
doSpecCheckPerlSyntax(){

	doLog "DEBUG START doSpecCheckPerlSyntax"
	
	cat docs/txt/url-shooter/specs/check-perl-syntax.spec.txt
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 

	doLog "DEBUG STOP  doSpecCheckPerlSyntax"
}
# eof func doSpecCheckPerlSyntax


# eof file: sfw/bash/url-shooter/funcs/check-perl-syntax.spec.sh
