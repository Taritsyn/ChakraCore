#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

PACKAGE_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_VERSION_FILE="$PACKAGE_ROOT/.pack-version"
PACKAGE_ARTIFACTS="$PACKAGE_ROOT/Artifacts"
if [ "$(uname)" = "Darwin" ]; then
    TARGET_OS_NAME="osx"
else
    TARGET_OS_NAME="linux"
fi
PACKAGE_NAME="Microsoft.ChakraCore.${TARGET_OS_NAME}-x64"
TARGET_NUGET_EXE="$PACKAGE_ROOT/nuget.exe"

if [ -d "$PACKAGE_ARTIFACTS" ]; then
    # Delete any existing output.
    rm $PACKAGE_ARTIFACTS/*.nupkg
fi

if [ ! -f "$TARGET_NUGET_EXE" ]; then
    SOURCE_NUGET_EXE="https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    echo "NuGet.exe not found - downloading latest from $SOURCE_NUGET_EXE"

    wget -O $TARGET_NUGET_EXE $SOURCE_NUGET_EXE || curl -o $TARGET_NUGET_EXE --location $SOURCE_NUGET_EXE
fi

VERSION_STR=$(<$PACKAGE_VERSION_FILE)
NUSPEC="$PACKAGE_NAME/$PACKAGE_NAME.nuspec"

# Create new package.
mono $TARGET_NUGET_EXE pack $NUSPEC -OutputDirectory $PACKAGE_ARTIFACTS -Properties version=$VERSION_STR
