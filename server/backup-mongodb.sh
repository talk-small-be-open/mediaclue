#!/bin/bash

set -e

pushd .. > /dev/null

NOW=$(date +"%Y%m%d%H%M")

BACKUP_DIR="backups/mongodb/mongodb_$NOW"

mkdir -p $BACKUP_DIR

mongodump --db=mediaclue --gzip --out=$BACKUP_DIR

# Delete old
find backups/mongodb/ -depth -iname "mongodb_*" -type d -not -newermt "100 days ago" -exec rm -dr "{}" \;

popd > /dev/null
