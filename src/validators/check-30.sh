#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L3C0]: Validator

USER_HOME="/home/Ghost-3"
TARGET_FILE='/tmp/notes.txt'
FAILURES=0

if [ ! -f "$TARGET_FILE" ]; then
    FAILURES=$((FAILURES + 1))
else
    CONTENT_LINES=`cat "$TARGET_FILE" | wc -l`
    if [ -z "$CONTENT_LINES" ] || [ $CONTENT_LINES -eq 0 ]; then
        FAILURES=$((FAILURES + 1))
    fi
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (3.0) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (3.0) complete!"
exit 0

