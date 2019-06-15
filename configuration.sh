# !/bin/bash

#use JSON


# function jsonval {
#     temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
#     echo ${temp##*|}
# }

response=`curl -s -d "clientId=client-id-abcd" -X POST https://private-a014d-singlelogin.apiary-mock.com/client/configuration`

# pos=`echo $(response) | awk match($1,"colorPrimary")`
# echo $pos
# temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop  | cut -d":" -f2| sed -e 's/^ *//g' -e 's/ *$//g' `
# echo ${temp##*|}

ls
pwd

# prop='colorPrimary'
# picurl=`jsonval`

# `curl -s -X POST $picurl`


