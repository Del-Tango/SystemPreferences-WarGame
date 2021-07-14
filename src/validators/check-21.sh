#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L2C1]: Validator

USER_HOME="/home/Ghost-2"
PID_FILE='/var/.s2c1.pid'
PROC_DIR='/proc'
PROC_FILE='stat'
FAILURES=0
INITIAL_PROC_NICE=0
TARGET_PIDS=()

if [ ! -f "$PID_FILE" ]; then
    FAILURES=$((FAILURES + 1))
else
    TARGET_PIDS=( `cat "$PID_FILE"` )
fi

for target_pid in ${TARGET_PIDS[@]}; do
    if [ -z "$target_pid" ]; then
        continue
    fi
    CHECK_ALIVE=`ps -aux | grep 'Ghost-2' | awk '{print $2}' | \
        egrep -v "[a-zA-Z]" | grep "$target_pid"`
    if [ ! -z $CHECK_ALIVE ]; then
        FAILURES=$((FAILURES + 1))
        continue
    fi
    PROCESS_NICENESS=`cat "${PROC_DIR}/${target_pid}/${PROC_FILE}" | \
        cut -d')' -f2 | awk '{print 17}'`
    if [ ! $PROCESS_NICENESS -le $INITIAL_PROC_NICE ]; then
        FAILURES=$((FAILURES + 1))
    fi
done

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (2.1) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (2.1) complete!"
exit 0

