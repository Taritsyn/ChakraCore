param($installPath, $toolsPath, $package, $project)

if ($project.Type -eq "Web Site") {
    $projectDirectoryPath = $project.Properties.Item("FullPath").Value
    $binDirectoryPath = Join-Path $projectDirectoryPath "bin"
    $pdbFileName = "ChakraCore.pdb"

    $pdbDirectoryPath = Join-Path $binDirectoryPath "x64"
    $pdbFilePath = Join-Path $pdbDirectoryPath $pdbFileName

    if (Test-Path $pdbFilePath) {
        Remove-Item $pdbFilePath -Force
    }
}
