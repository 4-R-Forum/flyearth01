$port= new-Object System.IO.Ports.SerialPort  COM3,115200,None,8,one
$port.Open()
while ($true){
  #$cmd_string = $port.ReadLine()
  #$cmd_string
  $port.ReadLine() |Out-Host
}
$port.Close()

