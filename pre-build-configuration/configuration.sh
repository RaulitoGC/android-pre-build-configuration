#!/bin/bash

# Function that gets back the value of the given key from JSON
COLOR_PRIMARY_KEY="COLOR_PRIMARY_KEY"
COLOR_PRIMARY_DARK_KEY="COLOR_PRIMARY_DARK_KEY"
COLOR_ACCENT_KEY="COLOR_ACCENT_KEY"

# Location of resource file to be replaced
LOCAL_COLOR_RESOURCE_PATH='../app/src/main/res/values/'

# Getting color resources from Remote Endpoint
URL='https://gist.githubusercontent.com/RaulitoGC/dba916a37a0e2299ce0b2af16692881e/raw/a69c30bb23777b861a762f431975864ecd60153e/android-color-configuration.json'
RESPONSE=$(curl "$URL")

mkdir -p output
cp 'colors-format.xml' 'output/'
mv output/colors-format.xml output/colors.xml

COLOR_PRIMARY=$(echo "$RESPONSE" | grep -o '"colorPrimary": "[^"]*' | grep -o '[^"]*$')
COLOR_PRIMARY_DARK=$(echo "$RESPONSE" | grep -o '"colorPrimaryDark": "[^"]*' | grep -o '[^"]*$')
COLOR_ACCENT=$(echo "$RESPONSE" | grep -o '"colorAccent": "[^"]*' | grep -o '[^"]*$')

#Replace values from network
sed -i '' -e "s/$COLOR_PRIMARY_KEY/$COLOR_PRIMARY/" output/colors.xml
sed -i '' -e "s/$COLOR_PRIMARY_DARK_KEY/$COLOR_PRIMARY_DARK/" output/colors.xml
sed -i '' -e "s/$COLOR_ACCENT_KEY/$COLOR_ACCENT/" output/colors.xml

# Move and replace the current local colors file for the remote one
cp -f output/colors.xml $LOCAL_COLOR_RESOURCE_PATH