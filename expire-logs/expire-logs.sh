#!/bin/bash
usage()
{
    echo "Usage: expire-logs.sh <log_folder> [days] [file_pattern]"
    echo "  <log_folder>: Folder that stores the log."
    echo "  [days]: How many days you want to keep the logs. Defaults to +365"
    echo "  [file_pattern]: File pattern name. Defaults to '*.gz'"
}

if [ -z $1 ]; then
    echo "Please provide the log folder."
    usage
    exit 1
fi

if [ -z $2 ]; then
    old='+365'
else
    old=$2
fi

if [ -z $3 ]; then
    pattern='*.gz'
else
    pattern=$3
fi

find $1 -mtime $old -name $pattern -exec rm -rf {} \;
