#!/bin/bash

# Getting color resources from Remote Endpoint
URL='https://gist.githubusercontent.com/RaulitoGC/dba916a37a0e2299ce0b2af16692881e/raw/5f6d24fa5ebc177c080f414676a5d37741bb4b00/android-color-configuration.json'
RESPONSE=$(curl "$URL")

# Array of color keys from remote resource and its size
REMOTE_COLOR_KEYS=('"colorPrimary"' '"colorPrimaryDark"' '"colorAccent"' '"imageColor"')
SIZE=${#REMOTE_COLOR_KEYS[@]}

# Array of local keys that will be used to update its value
LOCAL_COLOR_KEYS=("COLOR_PRIMARY_KEY" "COLOR_PRIMARY_DARK_KEY" "COLOR_ACCENT_KEY" "COLOR_IMAGE_KEY")

# This is a help array to keep track the values after doing some parsing
LOCAL_COLOR_VALUES=()

# Helper function to get specific color from response
# $1 = color key in order to gets its respective value
# i.e : {"primaryColor": "#AABBCC"} -> $1 = primaryColor and its return = "$#AABBCC"
function getColorValue {
    echo $RESPONSE | grep -o $1': "[^"]*' | grep -o '[^"]*$';
}

# Helper function to replace values by specific key
# $1 = key to be replaces
# $2 = value that will be placed
# $3 = file location
# i.e : color.xml = <color name="primaryColor">PRIMARY_COLOR_KEY</color>
# $1 = PRIMARY_COLOR_KEY, $2 = #AABBCC and $3 = colors.xml
function replaceValues {
    sed -i '' -e "s/$1/$2/" $3
}

# Getting color for every remote key 
for((i=0; i < $SIZE; i++)); do
  LOCAL_COLOR_VALUES+=($(getColorValue ${REMOTE_COLOR_KEYS[$i]}))
done

# ================ Android ====================

# Location of android local resource file to be replaced
LOCAL_COLOR_RESOURCE_PATH='../android/app/src/main/res/values/'

# Creating output folder, copy the color file format and rename it
mkdir -p android-output
cp 'android-colors-format.xml' 'android-output/'
mv android-output/android-colors-format.xml android-output/colors.xml

#Replace values from network to our local andorid file using local keys
for((i=0; i < $SIZE; i++)); do
  replaceValues ${LOCAL_COLOR_KEYS[$i]} ${LOCAL_COLOR_VALUES[$i]} android-output/colors.xml
done

# Move and replace the current local colors file
cp -f android-output/colors.xml $LOCAL_COLOR_RESOURCE_PATH

# ================ iOS ====================

# Location of iOS local resource file to be replaced
LOCAL_IMAGE_COLOR_RESOURCE_PATH='../iOS/iOS-pre-build-configuration/theme.xcassets/'

# Create a folder for the output on iOS
mkdir -p ios-output

# iOS color resources are splited by folders
# This array helps to create folders with a single loop
IOS_FOLDERS=(colorPrimary.colorset colorPrimaryDark.colorset colorAccent.colorset imageColor.colorset)
for i in "${!IOS_FOLDERS[@]}"; do 
  mkdir -p ios-output/${IOS_FOLDERS[$i]}
done

# Creating output folder, copy the color file format and rename it
for i in "${!IOS_FOLDERS[@]}"; do 
  cp 'ios-color-format.json' ios-output/${IOS_FOLDERS[$i]}
  mv ios-output/${IOS_FOLDERS[$i]}/ios-color-format.json ios-output/${IOS_FOLDERS[$i]}/Contents.json
done

# The resource color on iOS is splited as red, green and blue value
# this array helps to replace the values from the local ios file with
# the real values using these its respective key
IOS_HEX_COLOR_KEYS=("COLOR_RED_KEY" "COLOR_GREEN_KEY" "COLOR_BLUE_KEY")

for((i=0; i < $SIZE; i++)); do

    # Based on that, the first step is to get these values from the hex color
    # i.e : LOCAL_COLOR_VALUES[0] = "#AABBCC"
    # red color = LOCAL_COLOR_VALUES[0]:1:2 = AA
    # red green = LOCAL_COLOR_VALUES[0]:3:2 = BB
    # red blue = LOCAL_COLOR_VALUES[0]:5:2 = CC

    IOS_HEX_COLOR_VALUES=()
    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:1:2})
    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:3:2})
    IOS_HEX_COLOR_VALUES+=(${LOCAL_COLOR_VALUES[$i]:5:2})
    
    # Once we have red, green and blue colors, we can replace it using replaceValues
    # method and move that local file previously updated from ios-output/ folder 
    # to the real ios project folder

    for j in "${!IOS_HEX_COLOR_KEYS[@]}"; do
        replaceValues ${IOS_HEX_COLOR_KEYS[$j]} ${IOS_HEX_COLOR_VALUES[$j]} ios-output/${IOS_FOLDERS[$i]}/Contents.json
        cp -f ios-output/${IOS_FOLDERS[$i]}/Contents.json $LOCAL_IMAGE_COLOR_RESOURCE_PATH/${IOS_FOLDERS[$i]}/
    done
    
done
