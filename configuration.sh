#!/bin/bash

# Location of resource file to be replaced
LOCAL_COLOR_RESOURCE_PATH='app/src/main/res/values/'

# Getting color resources from Remote Endpoint
REMOTE_COLOR_RESOURCES_NAME='colors.xml'
URL='https://gist.githubusercontent.com/RaulitoGC/ab8141159523baaf45a739a666e5d791/raw/980680073b91fe3370b1efbe3d25237d8db1b4b0/android-color-configuration.xml'
curl "$URL" --output $REMOTE_COLOR_RESOURCES_NAME

# Move and replace the current local colors file for the remote one
mv -f $REMOTE_COLOR_RESOURCES_NAME $LOCAL_COLOR_RESOURCE_PATH
