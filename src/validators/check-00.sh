#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L0C0]: Validator

EXPECTED_ANSWER="binbootdevetchomelibmediamntoptprocrootrunsbinsrvsystmpusrvar"
PLAYER_ANSWER=`echo "${@:2}" | sed 's/ //g'`

if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWER" ]]; then
    echo "[ OK ]: Chapter (0.0) complete! ($PLAYER_ANSWER)"
    exit 0
fi

echo "[ NOK ]: Chapter (0.0) validation failure! ($PLAYER_ANSWER)"
exit 1

