param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $projectDir = $project.Properties.Item("FullPath").Value

    $assemblyDestDir = Join-Path $projectDir "bin/arm"
    if (!(Test-Path $assemblyDestDir)) {
        New-Item -ItemType Directory -Force -Path $assemblyDestDir
    }

    $assemblySourceFile = Join-Path $installPath "runtimes/win-arm/native/ChakraCore.dll"
    Copy-Item $assemblySourceFile $assemblyDestDir -Force
}
