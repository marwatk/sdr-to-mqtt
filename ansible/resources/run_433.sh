#!/bin/bash

set -e

killall rtl_433 >/dev/null 2>&1 || true

# We output json instead of mqtt directly so we can filter duplicates and not clutter mqtt with them
/usr/local/bin/rtl_433 \
        -T {{ rtl_433_seconds_to_run | default( 60 ) }} \
        -G \
        -M time:iso \
        -M newmodel \
        -F json \
        | \
    stdbuf -o0 uniq --skip-chars=31 | \
    mosquitto_pub \
            --stdin-line \
            --topic sensors/433_raw \
            --host {{ mqtt_server }} \
            --port {{ mqtt_port }} \
            --pw {{ mqtt_pass }} \
            --username {{ mqtt_user }}
