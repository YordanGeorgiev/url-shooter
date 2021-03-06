# v1.0.9
#------------------------------------------------------------------------------
# scan all the "defined" actions and generate the 
# spec , func , test , doc files if the do not exist 
#------------------------------------------------------------------------------
doGenerateActionFiles(){
	
	doLog "DEBUG START : doGenerateActionFiles"
	
	# for each defined action 	
	while read -r act ; do (

		doLog "DEBUG START :: checking action: $act"
			# for each defined action 	
			while read -d" " deliverable_type ; do (

				doLog "DEBUG START ::: action: $act - deliverable_type: $deliverable_type "
				# src: https://gist.github.com/tyru/358703
				func_part_name=$(echo $act|perl -ne 's{(\w+)}{($a=lc $1)=~s<(^[a-z]|-[a-z])><($b=uc$1);$b;>eg;$a;}eg;s|-||g;print')
				doLog "DEBUG func_part_name: $func_part_name"
				
				# foreach deliverable_type build the code and doc files	
				case $deliverable_type in 
					'spec')
					#
						full_func="doSpec""$func_part_name"
						deliverable_doc_file="docs/txt/$wrap_name/specs/$act.spec.txt"
						deliverable_code_file="sfw/bash/$wrap_name/specs/$act.spec.sh"
					;;
					'func')
						full_func="do""$func_part_name"
						deliverable_doc_file="docs/txt/$wrap_name/funcs/$act.func.txt"
						deliverable_code_file="sfw/bash/$wrap_name/funcs/$act.func.sh"
					;;
					'test')
						full_func="doTest""$func_part_name"
						deliverable_doc_file="docs/txt/$wrap_name/tests/$act.test.txt"
						deliverable_code_file="sfw/bash/$wrap_name/tests/$act.test.sh"
					;;
					'help')
						full_func="doHelp""$func_part_name"
						deliverable_doc_file="docs/txt/$wrap_name/helps/$act.help.txt"
						deliverable_code_file="sfw/bash/$wrap_name/helps/$act.help.sh"
					;;
				esac

				doLog " DEBUG full_func: $full_func"
				doLog " INFO delvr_doc_file: $deliverable_doc_file"
				doLog " INFO delvr_code_file: $deliverable_code_file"
				doLog " DEBUG STOP  ::: action: $act - deliverable_type: $deliverable_type "

				# if the delivable file does not exist create it
				code_file_exists=$(find "sfw/bash/$wrap_name/$deliverable_type""s" | grep $act.$deliverable_type.sh| wc -l)
				if [ $code_file_exists -eq 0 ];then

					cp -v sfw/bash/$wrap_name/funcs/%act%.%deliverable_type%.sh "$deliverable_code_file"
					perl -pi -e "s|%full_func%|$full_func|g" "$deliverable_code_file"
					perl -pi -e "s|%act%|$act|g" "$deliverable_code_file"
					perl -pi -e "s|%deliverable_type%|$deliverable_type|g" "$deliverable_code_file"

				fi
				
				doc_file_exists=$(find "docs/txt/$wrap_name/$deliverable_type""s" | grep $act.$deliverable_type.txt| wc -l)
				if [ $doc_file_exists -eq 0 ];then

					cp -v docs/txt/url-shooter/tmpl/%act%.%deliverable_type%.txt "$deliverable_doc_file"
					perl -pi -e "s|%full_func%|$full_func|g" "$deliverable_doc_file"
					perl -pi -e "s|%act%|$act|g" "$deliverable_doc_file"
					perl -pi -e "s|%deliverable_type%|$deliverable_type|g" "$deliverable_doc_file"

				fi
			); 
			done< <(echo 'spec' 'func' 'test' 'help' 'none')

		doLog "DEBUG STOP  :: checking action: $act"
		
	); 
	done< <(cat sfw/bash/$wrap_name/tests/all-url-shooter-tests.lst)
	
	doLog "DEBUG STOP  : doGenerateActionFiles"

}
#eof func doGenerateActionFiles
