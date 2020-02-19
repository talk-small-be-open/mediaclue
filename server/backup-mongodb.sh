#!/bin/bash

pushd .. > /dev/null

NOW=$(date +"%Y%m%d%H%M")

BACKUP_DIR="backups/mongodb/mongodb_$NOW"

mkdir -p $BACKUP_DIR

mongodump --db=mediaclue --gzip --out=$BACKUP_DIR

popd > /dev/null
