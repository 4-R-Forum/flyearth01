Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$Keys = [OpenQA.Selenium.Keys]
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
#$By = [OpenQA.Selenium.By]
$driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds(4)
Read-Host "Navigate to starting point"
$action = New-Object OpenQA.Selenium.Interactions.Actions($driver)
function press($key){
  $action.KeyDown($key)
  $action.KeyUp($key)
  $action.Perform()  
}

for ($i = 0; $i -lt 10; $i++) {
  press($Keys::ArrowUp)
}

$driver.Close()