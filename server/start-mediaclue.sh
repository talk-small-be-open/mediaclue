#!/bin/bash

source /etc/mediaclue/mediaclue.env

# Xpra display number
export DISPLAY=:100

xpra start --no-pulseaudio :100

sleep 2

# pathes
MAINDIR="/opt/mediaclue/main"
VMDIR="/opt/mediaclue/pharo"
PID_FILE="$VMDIR/mediaclue.pid"

NOW=$(date +"%Y%m%d%H%M")

cd $VMDIR

# Start Pharo
./pharo-ui mediaclue.image --no-default-preferences > $MAINDIR/log/pharo_$NOW.log 2>&1  &

# Get PID
sleep 2
pgrep pharo > $PID_FILE
