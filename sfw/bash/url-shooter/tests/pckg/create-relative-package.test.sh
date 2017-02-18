#!/bin/bash


# v1.1.0
#------------------------------------------------------------------------------
# creates a package from the relative file paths specified in the .dev file
#------------------------------------------------------------------------------
doTestCreateRelativePackage(){
	doLog " START : create-relative-package.test"

	doSpecCreateRelativePackage

	doHelpCreateRelativePackage
	
	# test the call with the include file of the current env - usually dev
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-package
	test -z "$sleep_interval" || sleep "$sleep_interval"
	
	# test the call with the include file of the tst env
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-package -i meta/.tst.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
	
	# test the call with the include file of the prd env
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-package -i meta/.prd.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
	
	# test the call with the include file of the prd env
	bash sfw/bash/url-shooter/url-shooter.sh -a create-relative-package -i meta/.git.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
	
	doLog " STOP  : create-relative-package.test"
}
#eof doCreateRelativePackage
