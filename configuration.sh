# !/bin/bash

colorPrimaryKey=""

response=`curl -s -d "clientId=client-id-abcd" -X POST https://private-a014d-singlelogin.apiary-mock.com/client/configuration`

IFS=','
array=( $response )

for value in "${array[@]}"
do
	#echo $value
	case $value in
	   *colorPrimaryDark*)
	      	temp=${value#*:}
	      	colorPrimaryDark="${temp//\"}"
	      	;;
	   *colorPrimary*)
	      	temp=${value#*:}
	      	colorPrimary="${temp//\"}"
	      	;;
	   *colorAccent*)
	      	temp=${value#*:}
	      	colorAccent="${temp//\"}"
	      	;;
		*logo*)
	      	logo=${value#*:}
	      	;;
	   *)
	 		echo "$value is unknown"
	     	;;
	esac
done

