#!/bin/bash

find /opt/mediaclue/main/tmp/ -not -newermt "3 days ago" -type f,l -delete

find /opt/mediaclue/main/tmp/ -type d -empty -delete
