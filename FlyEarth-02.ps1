Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
#$By = [OpenQA.Selenium.By]
$driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds(4)
Read-Host "Navigate to starting point"
#$earth_app = $driver.FindElements($By::XPath("/html/body/earth-app"))
#$down = $earth_app.FindElement($By::Id("zoom-in"))
#$down
$action = New-Object OpenQA.Selenium.Interactions.Actions($driver)
#$action.KeyDown([OpenQA.Selenium.Keys]::Shift)
$Keys = New-Object OpenQA.Selenium.Keys($action)
for ($i = 0; $i -lt 10; $i++) {
  $action.KeyDown($Keys.ARROW_UP)
  #$action.SendKeys("a")
  $action.Perform()
}


$driver.Close()