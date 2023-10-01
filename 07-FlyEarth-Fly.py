#Add-Type -Path "C:\Portable\Selenium\WebDriver.dll"
import sys
import datetime
import serial
import selenium
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

# $By = [OpenQA.Selenium.By]
driver = webdriver.Chrome()
# $By = [OpenQA.Selenium.By]

# $Keys  = [OpenQA.Selenium.Keys]
#$sh  = $Keys::Shift
sh = Keys.SHIFT
alt = Keys.ALT
au =  Keys.ARROW_UP
ad =  Keys.ARROW_DOWN
al =  Keys.ARROW_LEFT
ar =  Keys.ARROW_RIGHT
pu =  Keys.PAGE_UP
pd =  Keys.PAGE_DOWN
# $driver.Navigate().GoToURL("https://earth.google.com/") | Out-Null
driver.get  ("https://earth.google.com/")
# Read-Host "Navigate in Earth to starting point, press Enter to Fly"
input("Navigate in Earth to starting point, press Enter to Fly")
# $action = New-Object OpenQA.Selenium.Interactions.Actions($driver)
action = ActionChains(driver)

def kd(key):
  action.KeyDown(key)
def ku(key):
  action.KeyDown(key)

try:
  port = serial.Serial('COM3',115200,8)
except:
  sys.stdout.write("Cannot open Port COM3")
  sys.exit()

i = 0
l = datetime.datetime.now()
m =""
cmd_string = ""
while True :
  try: 
    # get command 
    cmd_string = port.ReadLine()
    cmd_string = port.ReadLine()
  except:
    break

#process
m = ""
cmds = cmd_string.split(",")
if len(cmds) != 3  : #ignore more than 3 commands
  button = int(cmds[0])
  pitch =  int(cmds[1])
  roll = int(cmds[2])
if button !=  0:  # look up /down 
  # one time change view
  # ignore pitch/roll this loop
  # look up  = shift arrow down
  kd(sh)
  if button == 1:
    k = ad
    m += "LookUp"
  else:
    k = au
    m += "LookDown"
  kd(k)
  action.Perform()
elif (pitch < 20
  and   pitch > -20
  and   roll < 20
  and   roll > -20):
    # level, continuous fly forward
    # ///TODO Sep-21-1 this is a bit too fast
    ku(sh) # no shift
    ku(pd) # stop going up
    ku(pu)# stop going down
    kd(au) # press and hold arrow up to keep going forward
    action.Perform()
    m = "Level"
else:  
  # need to change direction, altitude, do one or the other this loop
  # direction first, repeat turn, no forward
  ku(pd) # stop going up
  ku(pu) # stop going down
  if ((roll < 20) 
  or   (roll <-20) ): # if roll right or left
    # roll, go left = Right arrow
    kd(sh) # must shift
    # act on roll before pitch
    # works ok, but better if fwd too ///TODO Sep-21-2 how to repeat sh L/R, no shift up until next loop
    rk = None
    if roll > 0:
      rk = al
      m ="GoRight"
    if roll < 0:
        rk = ar
        m ="GoLeft"
    kd(rk)
    ku(sh)
    kd(au)
    action.Perform()
  else :
    # no roll
    # pitch, go down  = PageUp
    # works ok
    if pitch > 0:
       kd(pd)
       m ="GoUp"
    if pitch < 0:
      # /// TODO Sep-21-3 how to find camera-altituede element?
      #$altitude = $driver.FindElement($By::Id("camera-altitude"))
      #if ($altitude -le 100 ){ kd $pu ; $m ="GoDown"}
      kd(pu)
      m ="GoDown"
      kd(au)
    action.Perform()


  # logging
  i += 1
  n = datetime.datetime.now()
  e = n - l 
  l = n
  sys.stdout.write(str(i) + " " +str(e.total_seconds)  + " " + m )


port.Close()

