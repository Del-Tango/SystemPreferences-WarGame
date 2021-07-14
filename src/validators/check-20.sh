#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L2C0]: Validator

USER_HOME="/home/Ghost-2"
PID_FILE='/var/.s2c0.pid'
FAILURES=0
TARGET_PIDS=()

if [ ! -f "$PID_FILE" ]; then
    FAILURES=$((FAILURES + 1))
else
    TARGET_PIDS=( `cat "$PID_FILE"` )
fi

if [ ${#TARGET_PIDS[@]} -eq 0 ]; then
    FAILURES=$((FAILURES + 1))
else
    for target_pid in ${TARGET_PIDS[@]}; do
        if [ -z "$target_pid" ]; then
            continue
        fi
        CHECK_ALIVE=`ps -aux | grep 'Ghost-2' | awk '{print $2}' | \
            egrep -v "[a-zA-Z]" | grep "$target_pid"`
        if [ ! -z $CHECK_ALIVE ]; then
            FAILURES=$((FAILURES + 1))
        fi
    done
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (2.0) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (2.0) complete!"
exit 0

