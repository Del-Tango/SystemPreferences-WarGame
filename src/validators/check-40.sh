#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L4C0]: Validator

CRONTABS=`crontab -l | egrep -v '^#'`
FAILURES=0

if [ -z "$CRONTABS" ]; then
    FAILURES=$((FAILURES + 1))
else
    COMMANDS=( `echo "$CRONTABS" | awk '{print $6}'` )
    for fl_path in ${COMMANDS[@]}; do
        if [ ! -f "$fl_path" ] || [ ! -x "$fl_path" ] ; then
            FAILURES=$((FAILURES + 1))
        fi
    done
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (4.0) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (4.0) complete!"
exit 0

