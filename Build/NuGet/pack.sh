#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

PACKAGE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_ARTIFACTS_DIR="$PACKAGE_ROOT/Artifacts"
LOCAL_NUGET_EXE="$PACKAGE_ROOT/nuget.exe"

if [ -d "$PACKAGE_ARTIFACTS_DIR" ]; then
    # Delete any existing output.
    rm "$PACKAGE_ARTIFACTS_DIR/*.nupkg"
fi

if [ ! -f "$LOCAL_NUGET_EXE" ]; then
    NUGET_DIST_URL="https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    echo "NuGet.exe not found - downloading latest from $NUGET_DIST_URL"

    wget -O $LOCAL_NUGET_EXE $NUGET_DIST_URL || curl -o $LOCAL_NUGET_EXE --location $NUGET_DIST_URL
fi

PACKAGE_VERSION_FILE="$PACKAGE_ROOT/.pack-version"
PACKAGE_VERSION=$(<$PACKAGE_VERSION_FILE)

if [ "$(uname)" = "Darwin" ]; then
    OS_NAME="osx"
else
    OS_NAME="linux"
fi
PACKAGE_NAME="Microsoft.ChakraCore.${OS_NAME}-x64"
PACKAGE_NUSPEC_FILE="$PACKAGE_NAME/$PACKAGE_NAME.nuspec"

# Create new package.
mono $LOCAL_NUGET_EXE pack $PACKAGE_NUSPEC_FILE -OutputDirectory $PACKAGE_ARTIFACTS_DIR -Properties version=$PACKAGE_VERSION
