#!/bin/bash
set -e

killall rtl_tcp >/dev/null 2>&1 || true
killall -9 rtl_tcp >/dev/null 2>&1 || true
killall rtlamr >/dev/null 2>&1 || true
killall -9 rtlamr >/dev/null 2>&1 || true

/usr/bin/rtl_tcp >/dev/null 2>&1 &
sleep 1
{{ go_path }}/bin/rtlamr \
        -duration={{ rtlamr_seconds_to_run }}s \
        -filterid={{ rtlamr_meter_id }} \
        2>/dev/null | \
    stdbuf -oL uniq --skip-chars=31 | \
    mosquitto_pub \
            --stdin-line \
            --topic /sensors/power/meter \
            --host "{{ mqtt_server }}" \
            --port "{{ mqtt_port }}" \
            --pw "{{ mqtt_pass }}" \
            --username "{{ mqtt_user }}"
killall rtl_tcp
