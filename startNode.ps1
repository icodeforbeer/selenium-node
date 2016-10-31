param(
    $port = 5555,
    [string]$hubHost = "127.0.0.1",
    $hubPort = 4444,
    $toolsUrl = "https://github.com/saipuli/selenium-node/archive/master.zip"
)

$downloadsFolder = "$env:USERPROFILE\Downloads"
$workingFolder = "$downloadsFolder\selenium-node-master"

Write-Host "Remove the folder with old stuff"
Remove-Item $workingFolder -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Download new stuffs to $env:USERPROFILE\Downloads folder"
# Download the file to a specific location
$wc = new-object System.Net.WebClient
$downloadFileName = "$downloadsFolder\selenium-node-master.zip"
$wc.DownloadFile($toolsUrl,$downloadFileName)

Write-Host "Download completed, unzipping contents"
# Unzip the file to specified location
$shell_app=new-object -com shell.application
$zipFile = $shell_app.namespace($downloadFileName)
$destination = $shell_app.namespace($downloadsFolder)
$destination.Copyhere($zipFile.items())

Remove-Item "$downloadsFolder\selenium-node-master.zip" -Force -ErrorAction Ignore

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

Invoke-Expression $workingFolder\startup.ps1
