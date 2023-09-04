
Clear-Host
try {
  $port = new-Object System.IO.Ports.SerialPort  COM3,115200,None,8,one
  if (-not($Port.IsOpen)) { $port.Open()}
}
catch {
  Write-Host "Cannot open Port COM3, disconnect, reconnect USB and try again "
  
}
$i = 0
$l = get-date # first line

while ($true){
  $i += 1

  $n = get-date
  $e = $n - $l 
  $l = $n
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " " +  $port.ReadLine()  |Out-Host
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " " +  $port.ReadLine()  |Out-Host
  [string]$i + " " +[string]::format("{0:N}", $e.TotalSeconds)+ " " +  $port.ReadLine()  |Out-Host
}
$port.Close()

