#!/bin/bash
source /opt/james/settings/settings.sh
source $BASEDIR/include/func.*.sh

alert "Alert daemon started"

while true;
do
    if [ -f "$ALERTMESSAGES" ];
    then
        touch $ALERTMESSAGES.lock
        cp $ALERTMESSAGES $ALERTMESSAGES.tmp
        rm $ALERTMESSAGES
        rm $ALERTMESSAGES.lock
        mpc volume -30
        while read LINE;
        do
            if [ "a$LINE" != "a" ];
            then
                echo -e "$(date) alerting"
                $BASEDIR/scripts/alert.sh "$LINE"
                sleep 1
            fi
        done < $ALERTMESSAGES.tmp
        mpc volume +30
        rm $ALERTMESSAGES.tmp
    else
        sleep 1
    fi
done
