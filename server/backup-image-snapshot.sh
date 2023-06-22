#!/bin/bash

pushd .. > /dev/null

NOW=$(date +"%Y%m%d%H%M")

BACKUP_DIR="backups/image_snapshots"
mkdir -p $BACKUP_DIR

# tar the Pharo files
tar -czf $BACKUP_DIR/mediaclue_image_$NOW.tgz pharo/mediaclue.image pharo/mediaclue.changes

# Delete old
find $BACKUP_DIR -iname "*.tgz" -not -newermt "60 days ago" -delete

popd > /dev/null
