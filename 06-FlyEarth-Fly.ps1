Clear-Host
Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
$Keys = [OpenQA.Selenium.Keys]
$driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
Read-Host "Navigate in Earth to starting point, press Enter to Fly"
$action = New-Object OpenQA.Selenium.Interactions.Actions($driver)

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
$s = 1 # speed
while ($true){
  try { 
    # get command
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
  }

  # keystrokes ud,pitch,roll
  # go fwd at speed
  for ($f = 0; $f -lt $s; $f++){
    $action.KeyDown($Keys::ArrowUp) | Out-Null
    $action.KeyUp($Keys::ArrowUp) | Out-Null
  }
  # do buttons
  if (1 -eq $updown) {# go up
    $action.KeyDown($Keys::PageDown) | Out-Null
    $action.KeyUp($Keys::PageDown) | Out-Null
    $m = "GoUp"
  }
  elseif (-1 -eq $updown) { # go down
    $action.KeyDown($Keys::PageUp) | Out-Null
    $action.KeyUp($Keys::PageUp) | Out-Null
    $m = "GoDown"
  }
  # do pitch
  if ($pitch -gt 20) { # look up
    $action.KeyDown($Keys::Shift) | Out-Null
    $action.KeyDown($Keys::ArrowDown) | Out-Null
    $action.KeyUp($Keys::ArrowDown) | Out-Null
    $m = "LookUp"
    if  ($pitch -gt 55){ # look up again
      $action.KeyDown($Keys::ArrowDown) | Out-Null
      $action.KeyUp($Keys::ArroDown) | Out-Null
    }
    $action.KeyUp($Keys::Shift) | Out-Null
    $m = "LookUp2"
  } 
  # ditto elseif -lt 20
  if ($pitch -lt -20) { # look down
    $action.KeyDown($Keys::Shift) | Out-Null
    $action.KeyDown($Keys::ArrowUp) | Out-Null
    $action.KeyUp($Keys::ArrowUp) | Out-Null
    $m = "LookDown"
    if  ($pitch -lt -55){ # look up again
      $action.KeyDown($Keys::ArrowUp) | Out-Null
      $action.KeyUp($Keys::ArrowUp) | Out-Null
    }
    $action.KeyUp($Keys::Shift) | Out-Null
    $m = "LookDown2"
  } 
  # do roll
  if ($roll -gt 20) {
    $action.KeyDown($Keys::Shift) | Out-Null
    $action.KeyDown($Keys::ArrowLeft) | Out-Null
    $action.KeyUp($Keys::ArrowLeft) | Out-Null
    $m = "TurnRight"
    if ($roll -gt 55) {
      $action.KeyDown($Keys::ArrowLeft) | Out-Null
      $action.KeyUp($Keys::ArrowLeft) | Out-Null
      $m = "TurnRight2"
    }
    $action.KeyUp($Keys::Shift) | Out-Null
  }
  # ditto elseif -lt 20
  if ($roll -lt -20) {
    $action.KeyDown($Keys::Shift) | Out-Null
    $action.KeyDown($Keys::ArrowRight) | Out-Null
    $action.KeyUp($Keys::ArrowRight) | Out-Null
    $m = "TurnLeft"
    if ($roll -lt -55) {
      $action.KeyDown($Keys::ArrowRight) | Out-Null
      $action.KeyUp($Keys::ArrowRight) | Out-Null
      $m = "TurnLeft2"
    }
    $action.KeyUp($Keys::Shift) | Out-Null
  }
  # send keystrokes, single refresh
  $action.Perform() 
 
  # logging
  $i += 1
  $n = get-date
  $e = $n - $l 
  $l = $n
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " "  + $m |Out-Host
}

$port.Close()

