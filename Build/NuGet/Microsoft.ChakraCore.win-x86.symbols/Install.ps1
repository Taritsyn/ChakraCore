param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $projectDir = $project.Properties.Item("FullPath").Value

    $pdbDestDir = Join-Path $projectDir "bin/x86"
    if (!(Test-Path $pdbDestDir)) {
        New-Item -ItemType Directory -Force -Path $pdbDestDir
    }

    $pdbSourceFile = Join-Path $installPath "runtimes/win-x86/native/ChakraCore.pdb"
    Copy-Item $pdbSourceFile $pdbDestDir -Force
}
