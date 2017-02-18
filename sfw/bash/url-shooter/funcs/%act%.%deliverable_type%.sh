# sfw/bash/url-shooter/funcs/%act%.%deliverable_type%.sh

# v1.0.9
# ---------------------------------------------------------
# todo: add %full_func% comments ...
# ---------------------------------------------------------
%full_func%(){

	doLog "DEBUG START %full_func%"
	
	cat docs/txt/url-shooter/%deliverable_type%s/%act%.%deliverable_type%.txt
	
	test -z "$sleep_interval" || sleep "$sleep_interval"
	# add your action implementation code here ... 
	# Action !!!

	doLog "DEBUG STOP  %full_func%"
}
# eof func %full_func%


# eof file: sfw/bash/url-shooter/funcs/%act%.%deliverable_type%.sh
