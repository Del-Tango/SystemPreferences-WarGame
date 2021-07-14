#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L0C4]: Validator

EXPECTED_ANSWER='Giant Seeds'
PLAYER_ANSWER="${@:2}"
if [ ! -f "$PLAYER_ANSWER" ]; then
    echo "[ NOK ]: Chapter (0.4) validation failure! ($PLAYER_ANSWER)"
    exit 1
fi
FILE_CONTENT=`cat "$PLAYER_ANSWER" 2> /dev/null`
if [[ "$FILE_CONTENT" =~ $EXPECTED_ANSWER ]]; then
    echo "[ OK ]: Chapter (0.4) complete! ($PLAYER_ANSWER)"
    exit 0
fi
echo "[ NOK ]: Chapter (0.4) validation failure! ($PLAYER_ANSWER)"
exit 1
