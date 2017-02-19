# url-shooter

A bash Perl based wrapper around curl to shoot at lots of urls ...

## PURPOSE 
To run in the shell an exported postman v2 json collection with ok / nok results by passing exported
headers data as well 

## SETUP
```
      # go to a base dir ( could be /opt , /var or whatever you have rwx to )
      cd /tmp/
      
      # clone the project ( should have git ssh access configured ... )
      git clone git@github.com:YordanGeorgiev/url-shooter.git
      ls -al
      
      # setup some vars for the tgt dir structure
      export base_dir=/tmp
      export org=my_org
      export product_name=url-shooter
      export ver=0.2.5
      export my_initials=your_initials

      # create the needed dir structure
      mkdir -p $base_dir/$org/$product_name/
      mv -v ./$product_name $base_dir/$org/$product_name/"$product_name"."$ver".git."$my_initials"

      # and verify
      find $base_dir/$org/$product_name/"$product_name"."$ver".git."$my_initials" | less
      cd $base_dir/$org/$product_name/"$product_name"."$ver".git."$my_initials"

      # and fork a new product instance and start hacking
      bash sfw/bash/url-shooter/url-shooter.sh -a to-ver=0.2.6
      
      cd $base_dir/$org/$product_name/"$product_name"."0.2.6".dev."$my_initials" 
      # run the configured tests to run 
      bash sfw/bash/url-shooter/test-url-shooter.sh 
      
      # set the path to the postman export collection as json-file
      json_file=./data/json/example.postman_collection.json"
      # Action !!!
      perl sfw/perl/url_shooter/script/url_shooter.pl --json-file "$json_file"

```



## FUTURE THOUGHTS 
multiple url store provides ( not only postman url exported collections ) 
all put post delete http methods + configurability
fetch url data from db ( internal url objects data format ) 
To run in the shell an exported postman v2 json collection with ok / nok results by passing exported
headers data as well 
speed !!!
threading !!!
