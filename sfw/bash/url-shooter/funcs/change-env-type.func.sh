# sfw/bash/url-shooter/funcs/change-env-type.func.sh

# v1.1.2
# ---------------------------------------------------------
# todo: add doChangeEnvType comments ...
# ---------------------------------------------------------
doChangeEnvType(){

	doLog "DEBUG START doChangeEnvType"
	

	tgt_env="$1"
	tgt_environment_name=$(echo $environment_name | perl -ne "s/$env_type/$tgt_env/g;print")
	tgt_product_version_dir=$product_dir/$tgt_environment_name
	mkdir -p $tgt_product_version_dir	
	test $? -ne 0 && doExit 2 "Failed to create $tgt_product_version_dir !"

	test "$tgt_env" == "$env_type" && return
	# remove everything from the tgt product version dir - no extra files allowed !!!
	rm -fvr $tgt_product_version_dir/*
	test $? -eq 0  || doExit 2 "cannot write to $tgt_product_version_dir !"
	
	doCreateRelativePackage
	unzip -o $zip_file -d $tgt_product_version_dir
	cp -v $zip_file $tgt_product_version_dir

	doLog "DEBUG STOP  doChangeEnvType"
}
# eof func doChangeEnvType

# eof file: sfw/bash/url-shooter/funcs/change-env-type.func.sh
