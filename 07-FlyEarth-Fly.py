import sys
import datetime
import serial
#import selenium
from selenium import webdriver
#from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
# global variables
global cmd_string # commands from microbit via serial, 'buttonA/B,pitch,roll'
global port, button, pitch, roll, k, rk # for flying
global i, e, l, n, m # message for logging
i = 0 # set initial value

# create selenium objects
# $By = [OpenQA.Selenium.By]
driver = webdriver.Chrome()
action = ActionChains(driver)

# functions for keys
def kd(key):
  action.key_down(key)
def ku(key):
  action.key_up(key)
# variables for keys
ctrl = Keys.CONTROL
sh =   Keys.SHIFT
alt =  Keys.ALT
au =   Keys.ARROW_UP
ad =   Keys.ARROW_DOWN
al =   Keys.ARROW_LEFT
ar =   Keys.ARROW_RIGHT
pu =   Keys.PAGE_UP
pd =   Keys.PAGE_DOWN

# start Earth in Chrome
driver.get  ("https://earth.google.com/")
# Confirm you are ready to fly
input("Click through New Look popup")
# press ctrl-i to select .kml file for starting point, from dialog
kd(ctrl)
action.send_keys("i")
action.perform()
ku(ctrl)
input("Press shift and arrow multiple times to show horizon at top of screen")
"""
#press shift arrow_down 28 times to start 3D view and show horizon at top of screen
kd(sh)
for i in range(28):
  kd(ad)
  ku(ad)
  action.perform()
ku(sh)
"""

try:
  port = serial.Serial(port = "COM3", baudrate=115200,bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
except Exception as e:
  sys.stdout.write("Cannot open Port COM3: ")
  sys.stdout.writelines(str(e))
  sys.exit()

i = 0
l = datetime.datetime.now()

while True :
  try: 
    # get command 
    cmd_string = port.readline()
    cmd_string = port.readline()
  except Exception as e:
    sys.stdout.write(str(e))
    break
  else:
    #process
    m = ""
    i += 1
    n = datetime.datetime.now()
    e = n - l 
    l = n
    cmds = cmd_string.decode("utf-8").split(",")
    if len(cmds) == 3  : #ignore more than 3 commands
      try : # set values
        button = int(cmds[0])
        pitch =  int(cmds[1])
        roll = int(cmds[2])
      except: # use existing value
          pass
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
      action.perform()
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
        action.perform()
        m = "Level"
        sys.stdout.write(str(i) + " " +str(e)  + " " + m + "\r\n")
      # end of button and 
      # level

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
        action.perform()
        sys.stdout.write(str(i) + " " +str(e)  + " " + m + "\r\n")
      # end of roll
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
        action.perform()
        sys.stdout.write(str(i) + " " +str(e)  + " " + m + "\r\n")
      # end of pitch
      # end of button,pitch,roll
    # end of process
  # end of try read serial port
# end of while loop

port.Close()
# end of flight

