#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L0C2]: Validator

EXPECTED_ANSWER="-a"
PLAYER_ANSWER="${@:2}"

if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWER" ]]; then
    echo "[ OK ]: Chapter (0.2) complete! ($PLAYER_ANSWER)"
    exit 0
fi

echo "[ NOK ]: Chapter (0.2) validation failure! ($PLAYER_ANSWER)"
exit 1
