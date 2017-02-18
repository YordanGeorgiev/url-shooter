#!/bin/bash 

#v1.1.0
#------------------------------------------------------------------------------
# tests the full package creation
#------------------------------------------------------------------------------
doTestCreateFullPackage(){
	cd $product_version_dir
	doLog " INFO START : create-full-package.test"
	
	cat docs/txt/url-shooter/tests/pckg/create-full-package.test.txt

	doSpecCreateFullPackage

	doHelpCreateFullPackage

	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-package
	test -z "$sleep_interval" || sleep "$sleep_interval"
   printf "\033[2J";printf "\033[0;0H"

	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-package -i $product_version_dir/meta/.tst.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
   printf "\033[2J";printf "\033[0;0H"
	
	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-package -i $product_version_dir/meta/.prd.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
   printf "\033[2J";printf "\033[0;0H"
	
	bash sfw/bash/url-shooter/url-shooter.sh -a create-full-package -i $product_version_dir/meta/.git.url-shooter
	test -z "$sleep_interval" || sleep "$sleep_interval"
   printf "\033[2J";printf "\033[0;0H"

	doLog " INFO STOP  : create-full-package.test"
}
#eof test doCreateFullPackage
