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

cd android-modular-configuration/app/src/main/res/values/

tempFile="color-temp.xml"

IFS=$'\n'
file=colors.xml

for line in `cat $file`
do
  	case $line in
	   	*colorPrimaryDark*)
	      	echo "<color name=\"colorPrimaryDark\">$colorPrimaryDark</color>" >> $tempFile
	      	;;
      	*colorPrimary*)
	      	echo "<color name=\"colorPrimary\">$colorPrimary</color>" >> $tempFile
	      	;;
      	*colorAccent*)
	      	echo "<color name=\"colorAccent\">$colorAccent</color>" >> $tempFile
	      	;;
  		*)
 			echo $line >> $tempFile
     	;;
	esac
done

rm $file
mv $tempFile $file

cd ../../../../../
./gradlew assembleDebug




