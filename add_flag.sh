#!/bin/bash

timestamp=`date +%Y%m%d-%H%M`
EJ_PATH=/home/junior/junior20/intranet20/includes
IP_PATH=/home/eclass/intranetIP/includes
INTERFACE=`route -n | grep -m 1 0.0.0.0 | awk '{print $8}'`
IP=`ip -4 addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`

###############FUNCTION#################
function addFlag(){
sed -i "s|.*wsPath.*|$WSPATH\n\$powerlesson2_config['wsInternalPath'] = 'ws://$DOMAIN:6060/ws';|" $1
}

function checkHost(){
  if grep -Fq "$DOMAIN" /etc/hosts
  then
     echo "Okay"
  else
     echo "$IP $DOMAIN" >> /etc/hosts
  fi
}

#################MAIN#####################
if [ -d "/home/eclass/intranetIP/includes/" ]
then
   cd $IP_PATH
   WSPATH=`grep -r wsPath settings.php`
   DOMAIN=`echo $WSPATH | grep -o -P '(?<=//).*(?=/ws)'`
   echo $WSPATH
   echo $DOMAIN
   cp -p settings.php settings.$timestamp.php
   addFlag settings.php
   checkHost
else
   cd $EJ_PATH
   WSPATH=`grep -r wsPath global.php`
   DOMAIN=`echo $WSPATH | grep -o -P '(?<=//).*(?=/ws)'`
   echo $WSPATH
   echo $DOMAIN
   cp -p global.php global.$timestamp.php
   addFlag global.php
   checkHost
fi