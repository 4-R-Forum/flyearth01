Clear-Host
Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$Keys = [OpenQA.Selenium.Keys]
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
#$By = [OpenQA.Selenium.By]
$driver.Manage().Timeouts().ImplicitWait = [System.TimeSpan]::FromSeconds(4)
Read-Host "Navigate in Earth to starting point, press Enter to Fly"
$action = New-Object OpenQA.Selenium.Interactions.Actions($driver)
#$s = 3 # speed
function press($mod,$key){
  # now called separately for updown, pitch, roll, 3 times
  # so Left Go Left Go Left Go
  # rather than Left Left Left Go Go Go
  if ($null -ne $mod) {$action.KeyDown($mod)| Out-Null}
 if ($null -ne $key) {
    $action.KeyDown($key)| Out-Null
    $action.KeyUp($key)| Out-Null
  }
  else {
    $action.KeyDown($Keys::ArrowUp)| Out-Null
    $action.KeyUp($Keys::ArrowUp)| Out-Null   
  }
  if ($null -ne $mod) {$action.KeyUp($mod)| Out-Null} 
  $action.Perform() | Out-Null
  #Start-Sleep -Milliseconds 25
}
try {
  $port = new-Object System.IO.Ports.SerialPort  COM3,115200,None,8,one
  if (-not($Port.IsOpen)) { $port.Open()}
}
catch {
  Write-Host "Cannot open Port COM3"
  Exit
}
$i = 0
$l = get-date
$m =""
while ($true){
  try { 
    #read serial 3 times, to avoid delayed response
    $cmd_string = $port.ReadLine()
    $cmd_string = $port.ReadLine()
    $cmd_string = $port.ReadLine()
  }
  catch { break }

 #process
  $m = "Level"
  $cmds = $cmd_string.Split(",")
  if (3 -eq $cmds.Length){ #ignore more than 3 commands
    $updown =[int] $cmds[0]
    $pitch =  [int] $cmds[1]
    $roll = [int] $cmds[2]
    if     ( $updown -eq  1) {press        $null $Keys::PageUp;    $m ="GoUp"}
    elseif ( $updown -eq  -1) {press       $null $Keys::PageDown;  $m ="GoDown"}
    else {press $Null $Null ; press $Null $Null ; press $Null $Null}
    if     ($roll -gt  20)   {press $Keys::Shift $Keys::ArrowLeft;  $m ="TurnRight"} 
    elseif ($roll -lt  -20)  {press $Keys::Shift $Keys::ArrowRight; $m = "TurnLeft" }
    else {press $Null $Null ; press $Null $Null ; press $Null $Null}
    if     ($pitch -gt  20)  {press $Keys::Shift $Keys::ArrowDown ; $m = "LookUp" } 
    elseif ($pitch -lt  -20) {press $Keys::Shift $Keys::ArrowUp;    $m = "LookDown" } 
    else {press $Null $Null ; press $Null $Null ; press $Null $Null}
  }
  #for ($j = 0; $j -lt $s ; $j++){
  #  press $null $Keys::ArrowUp
  #}
  # logging
  $i += 1
  $n = get-date
  $e = $n - $l 
  $l = $n
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " "  + $m |Out-Host
}

$port.Close()

