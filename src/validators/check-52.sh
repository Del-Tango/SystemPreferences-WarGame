#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L5C2]: Validator

PORT_NUMBER=3162
PROC_FILE='/var/.s5c2.pid'
PROC_PID=`cat "${PROC_FILE}"`
PROC_CHECK=`ps -aux | grep 'nc -l' | grep -e "$PORT_NUMBER" -e "$PROC_PID"`

if [ -z "$PROC_CHECK" ]; then
    CNX_CHECK=`nc -w 1 localhost $PORT_NUMBER &> /dev/null`
    if [ $? -ne 0 ]; then
        echo "[ OK ]: Chapter (5.2) complete!"
        exit 0
    fi
fi

echo "[ NOK ]: Chapter (5.2) validation failure!"
exit 1

