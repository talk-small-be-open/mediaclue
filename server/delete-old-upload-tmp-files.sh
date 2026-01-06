#!/bin/bash

find /opt/mediaclue/main/tmp/ -not -newermt "3 days ago" -type f,l -delete

find /opt/mediaclue/main/tmp/ -mindepth 1 -type d -empty -delete
