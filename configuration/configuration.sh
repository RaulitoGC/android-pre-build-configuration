#!/bin/bash

# Getting color resources from Remote Endpoint
URL='https://gist.githubusercontent.com/RaulitoGC/dba916a37a0e2299ce0b2af16692881e/raw/5f6d24fa5ebc177c080f414676a5d37741bb4b00/android-color-configuration.json'
RESPONSE=$(curl "$URL")

REMOTE_COLOR_KEYS=('"colorPrimary"' '"colorPrimaryDark"' '"colorAccent"' '"imageColor"')
SIZE=${#REMOTE_COLOR_KEYS[@]}

LOCAL_COLOR_KEYS=("COLOR_PRIMARY_KEY" "COLOR_PRIMARY_DARK_KEY" "COLOR_ACCENT_KEY" "COLOR_IMAGE_KEY")
LOCAL_COLOR_VALUES=()

function getColorValue {
    echo $RESPONSE | grep -o $1': "[^"]*' | grep -o '[^"]*$';
}

function replaceValues {
    sed -i '' -e "s/$1/$2/" $3
}

# Parsing the json from network to our colors (colorPrimary, colorPrimaryDark and colorAccent)
for((i=0; i < $SIZE; i++)); do
  LOCAL_COLOR_VALUES+=($(getColorValue ${REMOTE_COLOR_KEYS[$i]}))
done

# ================ Android ====================


# Location of resource file to be replaced
LOCAL_COLOR_RESOURCE_PATH='../android/app/src/main/res/values/'

# Creating output folder, copy the color file format and rename it
mkdir -p android-output
cp 'android-colors-format.xml' 'android-output/'
mv android-output/android-colors-format.xml android-output/colors.xml

#Replace values from network to our local file using keys
for((i=0; i < $SIZE; i++)); do
  replaceValues ${LOCAL_COLOR_KEYS[$i]} ${LOCAL_COLOR_VALUES[$i]} android-output/colors.xml
done

# Move and replace the current local colors file
cp -f android-output/colors.xml $LOCAL_COLOR_RESOURCE_PATH


# ================ iOS ====================

LOCAL_IMAGE_COLOR_RESOURCE_PATH='../iOS/iOS-pre-build-configuration/theme.xcassets/'
IOS_FOLDERS=(colorPrimary.colorset colorPrimaryDark.colorset colorAccent.colorset imageColor.colorset)

mkdir -p ios-output

for i in "${!IOS_FOLDERS[@]}"; do 
  mkdir -p ios-output/${IOS_FOLDERS[$i]}
done


for i in "${!IOS_FOLDERS[@]}"; do 
  cp 'ios-color-format.json' ios-output/${IOS_FOLDERS[$i]}
  mv ios-output/${IOS_FOLDERS[$i]}/ios-color-format.json ios-output/${IOS_FOLDERS[$i]}/Contents.json
done

IOS_HEX_COLOR_KEYS=("COLOR_RED_KEY" "COLOR_GREEN_KEY" "COLOR_BLUE_KEY")
IOS_HEX_COLOR_VALUES=()

for i in "${!IOS_FOLDERS[@]}"; do 
  mkdir -p ios-output/${IOS_FOLDERS[$i]}
done

for((i=0; i < $SIZE; i++)); do

    IOS_HEX_COLOR_VALUES=()

    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:1:2})
    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:3:2})
    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:5:2})
    
    for j in "${!IOS_HEX_COLOR_KEYS[@]}"; do
        replaceValues ${IOS_HEX_COLOR_KEYS[$j]} ${IOS_HEX_COLOR_VALUES[$j]} ios-output/${IOS_FOLDERS[$i]}/Contents.json
        cp -f ios-output/${IOS_FOLDERS[$i]}/Contents.json $LOCAL_IMAGE_COLOR_RESOURCE_PATH/${IOS_FOLDERS[$i]}/
    done
    
done
