#!/bin/bash

#TEMPFILE=`tempfile --prefix=xscreensaver-pi-hdmi. --suffix=.pid`
TEMPFILE=`tempfile --prefix=hdmi. --suffix=.pid`
echo 0 > $TEMPFILE

interrupt_potential_sleeping_processes() {
    SLEEP_PID=0
    if [ -x $TEMPFILE ] ; then
        SLEEP_PID=`cat $TEMPFILE`
    fi
    if [ "0" != "$SLEEP_PID" ] ; then
        echo 0 > $TEMPFILE
        kill $SLEEP_PID
    fi
}


hdmi_off() {
    tvservice --off
}


hdmi_on() {
    # get the current state of HDMI output
    tvservice --status | grep -q HDMI
    RESULT=$?

    # if HDMI was not found, RESULT=1 ... turn it back on
    if [ "$RESULT" -eq 1 ] ; then
       tvservice --preferred
       fbset -depth 8
       fbset -depth 16
       xrefresh
    fi
}

# failsafe to make sure monitor stays on in case of quit
hdmi_on_exit() {
    interrupt_potential_sleeping_processes
    rm $TEMPFILE
    hdmi_on
    exit
}

#set -o monitor notify
#set -bm
#set +m

trap 'hdmi_on_exit' SIGQUIT SIGINT

hdmi_on

# see fancy process substitution down below
while read line ; do
    echo "RECEIVED: x${line}x"
    if [[ $line =~ ^BLANK ]] ; then
        echo "AAA $line XXX - blank"
        (
            sleep 3 
            hdmi_off
            echo 0 > $TEMPFILE
        ) &
        echo $! > $TEMPFILE
    fi
    if [[ $line =~ ^UNBLANK ]] ; then
        interrupt_potential_sleeping_processes
        hdmi_on
    fi
done < <( xscreensaver-command --watch )

echo ENDING

interrupt_potential_sleeping_processes
hdmi_on_exit
