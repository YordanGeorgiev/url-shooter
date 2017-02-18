# sfw/bash/url-shooter/funcs/gmail-package.test.sh

# v1.1.1
# ---------------------------------------------------------
# todo: add doTestGmailPackage comments ...
# ---------------------------------------------------------
doTestGmailPackage(){

	doLog "DEBUG START doTestGmailPackage"

	doSpecGmailPackage

	doHelpGmailPackage

	cat docs/txt/url-shooter/tests/pckg/gmail-package.test.txt

	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-package -a gmail-package
	test -z "$sleep_interval" || sleep "$sleep_interval"
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-package -a gmail-package	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-7z-package -a gmail-package	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-7z-package -a gmail-package
	test -z "$sleep_interval" || sleep "$sleep_interval"
	
	doLog "DEBUG STOP  doTestGmailPackage"
}
# eof func doTestGmailPackage

# eof file: sfw/bash/url-shooter/funcs/gmail-package.test.sh
