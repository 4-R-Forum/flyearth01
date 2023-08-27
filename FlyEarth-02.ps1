Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
$By = [OpenQA.Selenium.By]
$driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds(4)
Read-Host "Navigate to starting point"
$down = $driver.FindElement($By::Id("zoom-in"))


$driver.Close()