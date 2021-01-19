#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

$root = (Split-Path -Parent $MyInvocation.MyCommand.Definition) + '/..'

$packageRoot = "$root/NuGet"
$packageVersionFile = "$packageRoot/.pack-version"
$packageArtifacts = "$packageRoot/Artifacts"
$packageNames = "Microsoft.ChakraCore.win-x86", "Microsoft.ChakraCore.win-x64", "Microsoft.ChakraCore.win-arm", "Microsoft.ChakraCore", "Microsoft.ChakraCore.vc140"
$targetNugetExe = "$packageRoot/nuget.exe"

Function Create-NuGetPackage
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$PackageName,

        [Parameter(Mandatory)]
        [string]$Version,

        [switch]$Symbols
    )

    If ($Symbols)
    {
        $PackageName = "$PackageName.symbols"
    }

    $nuspec = "$packageRoot/$PackageName/$PackageName.nuspec"

    If (Test-Path $nuspec)
    {
        & $targetNugetExe pack $nuspec -OutputDirectory $packageArtifacts -Properties version=$Version
    }
}

If (Test-Path $packageArtifacts)
{
    # Delete any existing output.
    Remove-Item $packageArtifacts/*.nupkg
}

If (!(Test-Path $targetNugetExe))
{
    $sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    Write-Host "NuGet.exe not found - downloading latest from $sourceNugetExe"

    Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
}

$versionStr = (Get-Content $packageVersionFile)

ForEach ($packageName in $packageNames)
{
    # Create primary and “symbol” packages.
    Create-NuGetPackage $packageName $versionStr
    Create-NuGetPackage $packageName $versionStr -Symbols
}
