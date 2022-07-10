#!/bin/bash

program=$(readlink -f "$1");
if [ -z "$program" ]; then
    echo "Please provide a path to a program.";
    exit;
fi
args=$(echo "$2" | sed -e 's/ /\\ /g');

echo $program $args
echo "[runner] Starting steam. Make sure hyjacker is set up." > /tmp/hyjack.log

steam -applaunch 1162470 "--hyjack $program" "$args"> /dev/null 2>&1

tail -f /tmp/hyjack.log | awk '/\[hyjack\] Finished\./{exit}1;'

echo "[runner] Cleaning up..."
rm -f /tmp/hyjack.log