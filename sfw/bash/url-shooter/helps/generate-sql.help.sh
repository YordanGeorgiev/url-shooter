# sfw/bash/url-shooter/funcs/generate-sql.help.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doHelpGenerateSQL comments ...
# ---------------------------------------------------------
doHelpGenerateSQL(){

	doLog "DEBUG START doHelpGenerateSQL"
	
	cat docs/txt/url-shooter/helps/generate-sql.help.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!

	doLog "DEBUG STOP  doHelpGenerateSQL"
}
# eof func doHelpGenerateSQL


# eof file: sfw/bash/url-shooter/funcs/generate-sql.help.sh
