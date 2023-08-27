Add-Type -Path "C:\Users\1562969671E\Documents\WorkspaceD\Selenium\WebDriver.dll"

$driver = New-Object OpenQA.Selenium.Edge.EdgeDriver
$driver.Manage().Timeouts().ImplicitWait  = [System.TimeSpan]::FromSeconds(10)
$driver.Navigate().GoToURL("https://tosune5.robins.af.mil/pdm_gateway/search")
$By = [OpenQA.Selenium.By]
