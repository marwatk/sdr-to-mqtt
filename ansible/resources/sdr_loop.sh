#!/bin/bash

cd "${0%/*}"

pidfile=/var/run/sdr_loop.pid
if [ -e "$pidfile" ]; then
    pid=$(cat $pidfile)
    if kill -0 2>&1 > /dev/null "$pid"; then
        echo "Already running"
        exit 1
    else
        rm "$pidfile"
    fi
fi
echo $$ > "$pidfile"

while true; do
  ./run_433.sh
  ./run_amr.sh
done