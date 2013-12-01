#!/bin/bash

hdmi_off() {
    echo "HDMI-OFF!!";
    echo TEN NINE EIGHT .... tvservice --off
    export SLEEP_PID=0
}

hdmi_on() {
    echo "HDMI-ON!!";

    if [ "0" != "$SLEEP_PID" ] ; then
        echo "KILLING: $SLEEP_PID"
        kill $SLEEP_PID
        export SLEEP_PID=0
    fi

    #get the current tv state
    TVSTATE=`tvservice -s | grep HDMI | wc -l`

    #only turn on if its not already on
    if [ "$TVSTATE" -eq 0 ] ; then
       tvservice --preferred
       fbset -depth 8
       fbset -depth 16
       xrefresh
    else
       echo "HDMI already on";
    fi

}

finished() {
    echo FINISHED...
    export SLEEP_PID=0
}

#set -o monitor notify
set -bm

trap 'hdmi_on' SIGQUIT SIGINT

trap 'finished' SIGUSR1


export SLEEP_PID=0
echo SET SLEEP_PID=0
MY_PID=$$

hdmi_on

xscreensaver-command --watch | while read line ; do
    echo "RECEIVED: x${line}x"
    if [[ $line =~ ^BLANK ]] ; then
        echo "AAA $line XXX - blank"
        #(sleep 5 ; echo TEN NINE EIGHT ; kill -SIGUSR1 $$ ) &
        (
            MY_PP=$$
            sleep 3 
            hdmi_off
            kill -SIGUSR1 $MY_PP
            export SLEEP_PID=0
        ) &
        export SLEEP_PID="$!"
    fi
    if [[ $line =~ ^UNBLANK ]] ; then
        echo "BBB $line XXX - unblank"
        hdmi_on
    fi
done


echo ENDING

unset SLEEP_PID

hdmi_on
