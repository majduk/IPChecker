#!/bin/bash

CONFIGDIR="/home/apps/IPChecker/etc"
CONFIGFILE=$CONFIGDIR/"config.sh"
source "$CONFIGFILE";

/usr/sbin/logrotate --state $LOGDIR/logrotate.status $CONFIGDIR/"logrotate.cfg"  >> $LOGDIR/$LOGFILE 2>&1

echo `date $LOGDATEFORMAT`" +++++++++++++++++++++++ RUN START +++++++++++++++++++++++" >> $LOGDIR/$LOGFILE 2>&1

if [ -d "$WORKDIR" ]; then 
  echo `date $LOGDATEFORMAT`" $WORKDIR OK"  >> $LOGDIR/$LOGFILE 2>&1
else
  echo `date $LOGDATEFORMAT`" $WORKDIR - created work directory"  >> $LOGDIR/$LOGFILE 2>&1
  mkdir "$WORKDIR"  >> $LOGDIR/$LOGFILE 2>&1
fi

if [ -f "$WROKFILE" ]; then 
  echo `date $LOGDATEFORMAT`" $WROKFILE OK"  >> $LOGDIR/$LOGFILE 2>&1
else
  echo `date $LOGDATEFORMAT`" $WROKFILE - created work file"  >> $LOGDIR/$LOGFILE 2>&1
  touch "$WROKFILE"  >> $LOGDIR/$LOGFILE 2>&1
fi

read lastIP < "$WROKFILE"
echo `date $LOGDATEFORMAT`" last IP = $lastIP"  >> $LOGDIR/$LOGFILE 2>&1

currentIP=`/sbin/ifconfig eth0 | grep 'inet addr' | /usr/bin/awk '{ print $2 }'`
echo `date $LOGDATEFORMAT`" current IP = $currentIP"  >> $LOGDIR/$LOGFILE 2>&1 

if [ "$currentIP" != "$lastIP" ]; then
  echo `date $LOGDATEFORMAT`" IP changed, last=$lastIP, current=$currentIP"  >> $LOGDIR/$LOGFILE 2>&1
  $INSTALLDIR/bin/sendEmail.pl -f michal.ajduk@playmobile.pl -t michal.ajduk@playmobile.pl -u "GMLC IP" -m "GMLC IP changed, last=$lastIP, current=$currentIP" >> $LOGDIR/$LOGFILE 2>&1 
else
  echo `date $LOGDATEFORMAT`" IP not changed, last=$lastIP, current=$currentIP"  >> $LOGDIR/$LOGFILE 2>&1  
fi

echo $currentIP > "$WROKFILE"

echo `date $LOGDATEFORMAT`" +++++++++++++++++++++++ RUN   END +++++++++++++++++++++++"  >> $LOGDIR/$LOGFILE 2>&1
