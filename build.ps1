$addonVersionLineVanilla = Select-String -Pattern "## Version" -Path ".\Safeguard_Vanilla.toc"
$addonVersionVanilla = $addonVersionLineVanilla.ToString().Substring($addonVersionLineVanilla.ToString().LastIndexOf(" ") + 1)

$outputDirectoryPath = ".\Deploys"
$outputFileName = "Safeguard_$addonVersionVanilla"
if ((git branch).IndexOf("* main") -lt 0 -or (git status --porcelain).length -ne 0) {
  Write-Host "You are on a development branch or have uncommited changes."
  $currentDateTime = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
  $outputFileName = "$outputFileName-dev-$currentDateTime"
}

$outputFilePath = "$outputDirectoryPath\$outputFileName.zip"

if (Test-Path -Path "$outputFilePath") {
  throw "Output file with the same name already exists."
}

$tempDirectoryPath = "$outputDirectoryPath\Temp"
$tempSubDirectoryPath = "$tempDirectoryPath\Safeguard"
New-Item -Path ".\Deploys\Temp" -Name "Safeguard" -ItemType "directory" | Out-Null

Copy-Item ".\*" -Destination "$tempSubDirectoryPath" -Include *.lua,*.md,*.toc
Copy-Item ".\resources" -Destination "$tempSubDirectoryPath" -Recurse

$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
  throw "7 zip file '$7zipPath' not found"
}

Set-Alias 7zip $7zipPath
7zip a $outputFilePath $tempSubDirectoryPath

Remove-Item $tempDirectoryPath -Recurse

Write-Host "Successfully created deployment package: '$outputFilePath'"
