#!/bin/bash

# JUST FOR DEVELOPMENT ENVIRONMENTS
# 

OUTPUTFILE="/tmp/mediaclue_runTask_$1_output.txt"
MAXTIME=${2:-60}

# Vorheriges Outputfile löschen
rm -f $OUTPUTFILE

# App via http kontaktieren
STATUS=$(curl --silent --show-error --max-time $MAXTIME -w "%{http_code}" -o $OUTPUTFILE http://localhost:8087/runTask/$1)

if [ $STATUS -ne 200 ]; then
        echo "Fehler in Task $1:"
        cat $OUTPUTFILE
        exit 1
fi
