#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L0C5]: Validator

EXPECTED_ANSWER='Giant Seeds (+10xp)'
PLAYER_ANSWER="${@:2}"
if [ ! -f "$PLAYER_ANSWER" ]; then
    echo "[ NOK ]: Chapter (0.5) validation failure! ($PLAYER_ANSWER)"
    exit 1
fi
FILE_CONTENT=`cat "$PLAYER_ANSWER"`
if [[ "$FILE_CONTENT" == $EXPECTED_ANSWER ]]; then
    echo "[ OK ]: Chapter (0.5) complete! ($PLAYER_ANSWER)"
    exit 0
fi
echo "[ NOK ]: Chapter (0.5) validation failure! ($PLAYER_ANSWER)"
exit 1
