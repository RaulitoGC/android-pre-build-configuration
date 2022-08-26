#!/bin/bash

# Color keys from color-format.xml file
COLOR_PRIMARY_KEY="COLOR_PRIMARY_KEY"
COLOR_PRIMARY_DARK_KEY="COLOR_PRIMARY_DARK_KEY"
COLOR_ACCENT_KEY="COLOR_ACCENT_KEY"

# Location of resource file to be replaced
LOCAL_COLOR_RESOURCE_PATH='../app/src/main/res/values/'

# Getting color resources from Remote Endpoint
URL='https://gist.githubusercontent.com/RaulitoGC/dba916a37a0e2299ce0b2af16692881e/raw/a69c30bb23777b861a762f431975864ecd60153e/android-color-configuration.json'
RESPONSE=$(curl "$URL")

# Creating output folder, copy the color file format and rename it
mkdir -p output
cp 'colors-format.xml' 'output/'
mv output/colors-format.xml output/colors.xml

# Parsing the json from network to our colors (colorPrimary, colorPrimaryDark and colorAccent)
COLOR_PRIMARY=$(echo "$RESPONSE" | grep -o '"colorPrimary": "[^"]*' | grep -o '[^"]*$')
COLOR_PRIMARY_DARK=$(echo "$RESPONSE" | grep -o '"colorPrimaryDark": "[^"]*' | grep -o '[^"]*$')
COLOR_ACCENT=$(echo "$RESPONSE" | grep -o '"colorAccent": "[^"]*' | grep -o '[^"]*$')

#Replace values from network to our local file using keys
sed -i '' -e "s/$COLOR_PRIMARY_KEY/$COLOR_PRIMARY/" output/colors.xml
sed -i '' -e "s/$COLOR_PRIMARY_DARK_KEY/$COLOR_PRIMARY_DARK/" output/colors.xml
sed -i '' -e "s/$COLOR_ACCENT_KEY/$COLOR_ACCENT/" output/colors.xml

# Move and replace the current local colors file
cp -f output/colors.xml $LOCAL_COLOR_RESOURCE_PATH