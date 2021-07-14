#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L5C1]: Validator

PORT_NUMBER=9191
PROC_CHECK=` ps -aux | grep 'nc -l' | grep "$PORT_NUMBER"`

if [ -z "$PROC_CHECK" ]; then
    CNX_CHECK=`nc localhost $PORT_NUMBER -w 1 &> /dev/null`
    if [ $? -ne 0 ]; then
        echo "[ OK ]: Chapter (5.1) complete!"
        exit 0
    fi
fi

echo "[ NOK ]: Chapter (5.1) validation failure! ($FAILURES)"
exit 1

