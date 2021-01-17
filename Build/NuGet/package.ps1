#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

$root = (Split-Path -Parent $MyInvocation.MyCommand.Definition) + '/..'

$packageRoot = "$root/NuGet"
$packageVersionFile = "$packageRoot/.pack-version"
$packageArtifacts = "$packageRoot/Artifacts"
$packageNames = "Microsoft.ChakraCore.X86", "Microsoft.ChakraCore.X64", "Microsoft.ChakraCore.ARM", "Microsoft.ChakraCore", "Microsoft.ChakraCore.Symbols", "Microsoft.ChakraCore.vc140"
$targetNugetExe = "$packageRoot/nuget.exe"

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
    $nuspec = "$packageRoot/$packageName/$packageName.nuspec"

    If (Test-Path $nuspec)
    {
        # Create new package for current nuspec file.
        & $targetNugetExe pack $nuspec -OutputDirectory $packageArtifacts -Properties version=$versionStr
    }
}
