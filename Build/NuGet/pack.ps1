#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

$packageRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$packageVersionFile = "$packageRoot/.pack-version"
$packageArtifacts = "$packageRoot/Artifacts"
$packageNames = "Microsoft.ChakraCore.win-x86", "Microsoft.ChakraCore.win-x64", "Microsoft.ChakraCore.win-arm", "Microsoft.ChakraCore.win-arm64", "Microsoft.ChakraCore", "Microsoft.ChakraCore.vc140"
$targetNugetExe = "$packageRoot/nuget.exe"

# helper to create NuGet package
function Create-NuGetPackage ([string]$packageName, [string]$version, [switch]$symbols) {
    if ($symbols) {
        $packageName = "$packageName.symbols"
    }

    $nuspec = "$packageRoot/$packageName/$packageName.nuspec"

    if (Test-Path $nuspec) {
        & $targetNugetExe pack $nuspec -OutputDirectory $packageArtifacts -Properties version=$version
    }
}

if (Test-Path $packageArtifacts) {
    # Delete any existing output.
    Remove-Item $packageArtifacts/*.nupkg
}

if (!(Test-Path $targetNugetExe)) {
    $sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    Write-Host "NuGet.exe not found - downloading latest from $sourceNugetExe"

    Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
}

$versionStr = (Get-Content $packageVersionFile)

foreach ($packageName in $packageNames) {
    # Create primary and “symbol” packages.
    Create-NuGetPackage $packageName $versionStr
    Create-NuGetPackage $packageName $versionStr -Symbols
}
