#!/bin/bash

source /etc/mediaclue/mediaclue.env

# This task ends immediately, saving the image runs thereafter, so ...
./run-task.sh saveAndQuitPharo

# ... wait until no pharo process exists
while pgrep pharo > /dev/null; do sleep 1; done

# Remove PID file
if [ -e "/opt/mediaclue/pharo/mediaclue.pid" ]; then
        rm -f /opt/mediaclue/pharo/mediaclue.pid
fi
