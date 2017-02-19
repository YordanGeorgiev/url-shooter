# sfw/bash/url-shooter/funcs/run-perl-tests.func.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add doRunPerlTests comments ...
# ---------------------------------------------------------
doRunPerlTests(){
	
   cd $product_instance_dir
	doLog "INFO START : doRunPerlTests"

   while read -r test_file ; do 
      test_file_name=$(basename "$test_file")
      doLog "INFO START Component testing $test_file_name"
      perl "$test_file"
      doLog "INFO STOP  Component testing $test_file_name"
      test -z "$sleep_iterval" || sleep $sleep_iterval
   done < <(find "$product_instance_dir/sfw/perl/url_shooter/t" -type f -name '*.t')
	
	doLog "INFO STOP  : doRunPerlTests"
}
# eof func doRunPerlTests


# eof file: sfw/bash/url-shooter/funcs/run-perl-tests.func.sh
