#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L4C1]: Validator

CRONTABS=`crontab -l | egrep -v '^#'`
FAILURES=0

if [ ! -z "$CRONTABS" ]; then
    FAILURES=$((FAILURES + 1))
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (4.1) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (4.1) complete!"
exit 0

