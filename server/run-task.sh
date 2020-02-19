#!/bin/bash

source /etc/mediaclue/mediaclue.env

OUTPUTFILE="/tmp/mediaclue_runTask_$1_output.txt"
MAXTIME=${2:-60}

# Remove previous output file
rm -f $OUTPUTFILE

# Contact the app via HTTP (Seaside handler reacts on the "runTask" path)
STATUS=$(curl --silent --show-error --max-time $MAXTIME -w "%{http_code}" -o $OUTPUTFILE http://localhost:$MEDIACLUE_PHARO_PORT/runTask/$1)

# Capture errors
if [ $STATUS -ne 200 ]; then
    echo "Error in Task $1:"
    cat $OUTPUTFILE
    exit 1
fi
