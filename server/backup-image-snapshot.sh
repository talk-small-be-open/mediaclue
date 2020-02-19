#!/bin/bash

pushd .. > /dev/null

NOW=$(date +"%Y%m%d%H%M")

BACKUP_DIR="backups/image_snapshots"
mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/mediaclue_image_$NOW.tgz pharo/mediaclue.image pharo/mediaclue.changes

popd > /dev/null
