#!/bin/bash
source /opt/james/settings/settings.sh
source $BASEDIR/include/func.*.sh

/etc/init.d/motion stop
killall motion

if [ -f /var/run/motion/motion.pid ];
then
	rm /var/run/motion/motion.pid
fi

echo -e "\nJames iproximity monitor is now starting"
$BASEDIR/new_event.sh prx_went_away "Sleeping short ($PSHORT)"
$BASEDIR/new_event.sh alert "James Services are now online." "" &

PONLINE=0;
STATE=2
while /bin/true; do
    if [[ "$(check_pconnection)" -eq 1 ]];
    then
	PONLINE=1
	echo -e "DEBUG: $(date) $PINGDEVICEMAC online" >> $PDBGLOG

	READLOG=0
	if [ $STATE -ne "1" ];
	then
            cd $BOTDIR
            ONLINE=$($WHOISONLINE)
            cd $INPWD
            echo -e "$(date) master came online"

            STATE=1
	fi

    echo 1 > $PSTATEFILE
	$BASEDIR/new_event.sh prx_at_home "Sleeping long ($PLONG secs)"
    echo -e "$(date)\tsleeping for $PLONG seconds"

	sleep $PLONG

	while [[ $PONLINE -eq 1 ]]; do
	    if [[ "$(check_pconnection)" -eq 1 ]]; then
			echo -e "DEBUG: $(date) $PINGDEVICEMAC still online" >> $PDBGLOG
            echo -e "$(date)\tmaster still home, sleeping for $PLONG seconds"
			sleep $PLONG
	    else
			PONLINE=0
			echo -e "DEBUG: $(date) $PINGDEVICEMAC not longer online." >> $PDBGLOG
			echo -e "$(date)\tdevice away, sleeping for $PSHORT seconds"
			sleep $PSHORT
	    fi
	done
    else
	PONLINE=0
	echo -e "DEBUG: $(date) $PINGDEVICEMAC offline, short wait loop" >> $PDBGLOG

	if [ $STATE -ne "0" ];
	then
            cd $BOTDIR
            ONLINE=$($WHOISONLINE)
            cd $INPWD
            $BASEDIR/new_event.sh alert "You left." "" &
            echo -e "$(date)\tmaster went away! i am now a watchdog"

            STATE=0
	fi

    echo 0 > $PSTATEFILE
	$BASEDIR/new_event.sh prx_went_away "Sleeping short ($PSHORT)"
    echo -e "$(date)\tsleeping for $PSHORT seconds"

	sleep $PSHORT
    fi
done
