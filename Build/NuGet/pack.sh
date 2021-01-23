#!/bin/bash
#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

packageRoot="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
packageVersionFile="$packageRoot/.pack-version"
packageArtifacts="$packageRoot/Artifacts"
if [ "$(uname)" = "Darwin" ]; then
    targetOsName="osx"
else
    targetOsName="linux"
fi
packageName="Microsoft.ChakraCore.$targetOsName-x64"
targetNugetExe="$packageRoot/nuget.exe"

if [ -d "$packageArtifacts" ]; then
    # Delete any existing output.
    rm $packageArtifacts/*.nupkg
fi

if [ ! -f "$targetNugetExe" ]; then
    sourceNugetExe="https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    echo "NuGet.exe not found - downloading latest from $sourceNugetExe"

    wget -O $targetNugetExe $sourceNugetExe || curl -o $targetNugetExe --location $sourceNugetExe
fi

versionStr=$(<$packageVersionFile)

# Create new package.
nuspec="$packageName/$packageName.nuspec"
mono $targetNugetExe pack $nuspec -OutputDirectory $packageArtifacts -Properties version=$versionStr
