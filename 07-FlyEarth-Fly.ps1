Clear-Host
Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$By = [OpenQA.Selenium.By]
$Keys  = [OpenQA.Selenium.Keys]
  $sh  = $Keys::Shift
  $alt = $Keys::Alt
  $au =  $Keys::ArrowUp
  $al =  $Keys::ArrowLeft
  $ar =  $Keys::ArrowRight
  $pu =  $Keys::PageUp
  $pd =  $Keys::PageDown
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
Read-Host "Navigate in Earth to starting point, press Enter to Fly"
$action = New-Object OpenQA.Selenium.Interactions.Actions($driver)
function kd($key){
  $action.KeyDown($key) | Out-Null
}
function ku($key){
  $action.KeyUp($key) | Out-Null
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
    # get command 
    $cmd_string = $port.ReadLine()
    $cmd_string = $port.ReadLine()
  }
  catch { break }

#process
$m = ""
$cmds = $cmd_string.Split(",")
if (3 -eq $cmds.Length){ #ignore more than 3 commands
  $button =[int] $cmds[0]
  $pitch =  [int] $cmds[1]
  $roll = [int] $cmds[2]
}
if ($button -ne 0 ){ # look up /down 
  # one time change view
  # ignore pitch/roll this loop
  # look up  = shift arrow down
  kd $sh
  if ( $button -eq 1) { $k = $ad ; $m += "LookUp"}
  else { $k = $au ; $m += "LookDown"}
  kd $k
  $action.Perform()
}
elseif ( ($pitch -lt 20) `
  -and   ($pitch -gt -20) `
  -and   ($roll -lt 20) `
  -and   ($roll -gt -20) ){
    # level, continuous fly forward
    # ///TODO Sep-21-1 this is a bit too fast
    ku $sh # no shift
    ku $pd # stop going up
    ku $pu # stop going down
    kd $au # press and hold arrow up to keep going forward
    $action.Perform()
    $m = "Level"
  } 
else  {

  # need to change direction, altitude, do one or the other this loop
  # direction first, repeat turn, no forward
  ku $pd # stop going up
  ku $pu # stop going down
  if (($roll -gt 20) `
  -or   ($roll -lt -20) ){ # if roll right or left
    # roll, go left = Right arrow
    kd $sh # must shift
    # act on roll before pitch
    # works ok, but better if fwd too ///TODO Sep-21-2 how to repeat sh L/R, no shift up until next loop
    $rk = $null
    if ($roll -gt 0) { $rk = $al ; $m ="GoRight"}
    if ($roll -lt 0) { $rk = $ar ; $m ="GoLeft"}
    kd $rk
    ku $sh
    kd $au
    $action.Perform()
  }
  else {
    # no roll
    # pitch, go down  = PageUp
    # works ok
    if ($pitch -gt 0) { kd $pd ; $m ="GoUp"}
    if ($pitch -lt 0) {
      # /// TODO Sep-21-3 how to find camera-altituede element?
      #$altitude = $driver.FindElement($By::Id("camera-altitude"))
      #if ($altitude -le 100 ){ kd $pu ; $m ="GoDown"}
      kd $pu ; $m ="GoDown"
      kd $au
	    $action.Perform()
    }
  } 
}

  # logging
  $i += 1
  $n = get-date
  $e = $n - $l 
  $l = $n
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " "  + $m |Out-Host
}

$port.Close()

