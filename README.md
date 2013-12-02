xscreensaver-pi-hdmi(1) -- disable RaspberryPi HDMI after xscreensaver
======================================================================

SYNOPSIS
--------

`xscreensaver-pi-hdmi` [delay\_s]

DESCRIPTION
-----------

Raspberry Pi requires some special command execution to physically
turn on / off HDMI ports.  This utility cooperates with xscreensaver
to physically turn off and on the HDMI output when necessary.

`dpkg -S $(which tvservice)`  
`libraspberrypi-bin: /usr/bin/tvservice`  

Based on scripts in a forum post, but packaged for debian / raspbian.

  http://www.raspberrypi.org/phpBB3/viewtopic.php?t=56944&p=429723  
  by simonmcc » Mon Sep 30, 2013 7:49 am  

For the impatient:

`# direct control of HDMI / framebuffer needs special permissions`  
`sudo adduser $USER video`  

In your ~/.xsession file:

`# start xscreensaver`  
`xscreensaver &`  

`# start xscreensaver status monitor`  
`xscreensaver-pi-hdmi &`  

AUTHOR
------

Initial inspiration from simonmcc » Mon Sep 30, 2013 7:49 am   
(http://www.raspberrypi.org/phpBB3/viewtopic.php?t=56944&p=429723)  
Bash implementation and Debian packaging by Robert Ames <ramses0@yahoo.com>  

REPORTING BUGS
--------------

The project is hosted at https://github.com/ramses0/xscreensaver-pi-hdmi/
Issues and pull requests should be directed there.

It is an open question as to whether there is a better place to put
this "fix" ie: integrate directly into xscreensaver or where it makes
the most sense to completely "terminate" HDMI output to allow external
monitors to sleep.  Architectual suggestions and pointers are welcome.


