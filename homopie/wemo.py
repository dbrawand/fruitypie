#!/usr/bin/env python

import sys
from ouimeaux.environment import Environment

class WeMo(object):
    # SWITCH
    def _switch(self,switch):
        print "Switch found!", switch.name

    def _motion(self,motion):
         print "Motion found!", motion.name

    # INIT
    def __init__(self):
        self.env = Environment(self._switch,self._motion)
        #self.env = Environment()
        self.env.start()
        self.env.discover(seconds=2)
        self.switches = self.env.list_switches()
        self.motions = self.env.list_motions()
        self.active = None

    def select(self,n):
        self.active = self.env.get_switch(n)

def hms(x):
    h = int(x/3600)
    m = int((x % 3600)/60)
    s = x % 60
    return [h,m,s]

if __name__=="__main__":
    wemo = WeMo()
    for switch in wemo.switches:
        wemo.select(switch)
        print "{} is {}".format(wemo.active.name, "ON" if wemo.active.get_state() else "OFF")
        print "Energy  {:.2f}kWh".format(wemo.active.today_kwh)
        print "Power   {}W".format(wemo.active.current_power/1000)
        print "On Time {}h{}m{}s".format(*hms(wemo.active.today_on_time))
        print "On for  {}h{}m{}s".format(*hms(wemo.active.on_for))
        print "Standby {}h{}m{}s".format(*hms(wemo.active.today_standby_time))
