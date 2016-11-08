Write-Host "Updating the nodeConfig.json to include hijacked version and user capabilities"
$configFilePath = "$workingFolder\configs\nodeConfig.json"

$config = Get-Content -Raw -Path $configFilePath | ConvertFrom-Json
# Hack: hijacking version to route requests to a particular node, experimenting with additional capability elements for the same purpose.
foreach($capability in $config.capabilities){
    $capability | Add-Member NoteProperty "user" "$([Environment]::UserName)" -Force
    $capability | Add-Member NoteProperty "version" "$([Environment]::UserName)" -Force
}

Set-Content -Path $configFilePath  -Value ($config | ConvertTo-Json)

$hubUrl = "http://{0}:{1}/grid/register" -f $hubHost, $hubPort
Write-Host "Trying to register with $hubUrl with node on port $port"
java -jar "$workingFolder\selenium-server-standalone-2.53.1.jar" -role node -port $port -nodeConfig $configFilePath -hub $hubUrl -D"webdriver.chrome.driver=$workingFolder\drivers\chromedriver.exe" -D"webdriver.ie.driver=$workingFolder\drivers\IEDriverServer.exe" -D"webdriver.firefox.driver=$workingFolder\drivers\geckodriver.exe"
