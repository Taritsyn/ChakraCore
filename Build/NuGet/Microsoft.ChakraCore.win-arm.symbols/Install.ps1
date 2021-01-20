param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $runtimeDirectoryPath = Join-Path $installPath "runtimes/win-arm/"
    $projectDirectoryPath = $project.Properties.Item("FullPath").Value
    $binDirectoryPath = Join-Path $projectDirectoryPath "bin"
    $pdbFileName = "ChakraCore.pdb"

    $pdbDestDirectoryPath = Join-Path $binDirectoryPath "arm"
    if (!(Test-Path $pdbDestDirectoryPath)) {
        New-Item -ItemType Directory -Force -Path $pdbDestDirectoryPath
    }

    $pdbSourceFilePath = Join-Path $runtimeDirectoryPath ("native/" + $pdbFileName)
    Copy-Item $pdbSourceFilePath $pdbDestDirectoryPath -Force
}
