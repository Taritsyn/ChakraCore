param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $projectDir = $project.Properties.Item("FullPath").Value

    $pdbFile = Join-Path $projectDir "bin/x86/ChakraCore.pdb"
    if (Test-Path $pdbFile) {
        Remove-Item $pdbFile -Force
    }
}
