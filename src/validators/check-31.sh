#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L3C1]: Validator

TARGET_FILE='/tmp/notes.txt'
FAILURES=0

if [ ! -f "$TARGET_FILE" ]; then
    FAILURES=$((FAILURES + 1))
else
    CONTENT_LINES=`cat "$TARGET_FILE" | wc -l`
    if [ -z "$CONTENT_LINES" ] || [ $CONTENT_LINES -eq 0 ]; then
        FAILURES=$((FAILURES + 1))
    fi
    LAST_LINE=`tail -n1 "$TARGET_FILE"`
    if [[ "$LAST_LINE" != 'Thats the joke!...' ]]; then
        FAILURES=$((FAILURES + 1))
    fi
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (3.1) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (3.1) complete!"
exit 0

