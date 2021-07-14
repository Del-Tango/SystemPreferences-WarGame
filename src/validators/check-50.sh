#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L5C0]: Validator

PORT_NUMBER=1234
EXPECTED_ANSWER="nc -l -p $PORT_NUMBER"
PLAYER_ANSWER="${@:2}"

if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWER" ]]; then
    echo "[ OK ]: Chapter (5.0) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (5.0) validation failure! ($FAILURES)"
exit 1
