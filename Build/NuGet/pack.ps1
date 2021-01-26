#-------------------------------------------------------------------------------------------------------
# Copyright (C) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
#-------------------------------------------------------------------------------------------------------

$packageRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$packageArtifactsDir = Join-Path $packageRoot "Artifacts"
$localNugetExe = Join-Path $packageRoot "nuget.exe"

# helper to download file with retry
function DownloadFileWithRetry([string]$sourceUrl, [string]$destFile, [int]$retries) {
    $delayTimeInSeconds = 5

    while ($true) {
        try {
            Invoke-WebRequest $sourceUrl -OutFile $destFile
            break
        }
        catch {
            Write-Host "Failed to download $sourceUrl"

            if ($retries -gt 0) {
                $retries--

                Write-Host "Waiting $delayTimeInSeconds seconds before retrying. Retries left: $retries"
                Start-Sleep -Seconds $delayTimeInSeconds
            }
            else {
                $exception = $_.Exception
                throw $exception
            }
        }
    }
}

# helper to create NuGet package
function CreateNugetPackage ([string]$name, [string]$version, [switch]$symbols) {
    $packageName = if ($symbols) { "$name.symbols" } else { $name }
    $packageDir = Join-Path $packageRoot $packageName

    if (Test-Path $packageDir) {
        $packageNuspecFile = Join-Path $packageDir "$packageName.nuspec"

        & $localNugetExe pack $packageNuspecFile -OutputDirectory $packageArtifactsDir -Properties version=$version
    }
}

if (Test-Path $packageArtifactsDir) {
    # Delete any existing output.
    Remove-Item "$packageArtifactsDir/*.nupkg"
}

if (!(Test-Path $localNugetExe)) {
    $nugetDistUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

    Write-Host "NuGet.exe not found - downloading latest from $nugetDistUrl"
    DownloadFileWithRetry $nugetDistUrl $localNugetExe -retries 3
}

$packageVersionFile = Join-Path $packageRoot ".pack-version"
$packageVersion = (Get-Content $packageVersionFile)
$packageNames = @("Microsoft.ChakraCore.win-x86", "Microsoft.ChakraCore.win-x64",
    "Microsoft.ChakraCore.win-arm", "Microsoft.ChakraCore.win-arm64",
    "Microsoft.ChakraCore", "Microsoft.ChakraCore.vc140")

foreach ($packageName in $packageNames) {
    # Create primary and “symbol” packages.
    CreateNugetPackage $packageName $packageVersion
    CreateNugetPackage $packageName $packageVersion -symbols
}
