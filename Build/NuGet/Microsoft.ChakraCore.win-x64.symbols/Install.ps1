param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $projectDir = $project.Properties.Item("FullPath").Value

    $pdbDestDir = Join-Path $projectDir "bin/x64"
    if (!(Test-Path $pdbDestDir)) {
        New-Item -ItemType Directory -Force -Path $pdbDestDir
    }

    $pdbSourceFile = Join-Path $installPath "runtimes/win-x64/native/ChakraCore.pdb"
    Copy-Item $pdbSourceFile $pdbDestDir -Force
}