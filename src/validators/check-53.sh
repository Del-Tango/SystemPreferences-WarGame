#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L5C3]: Validator

EXPECTED_ANSWER="6a0624bdca8c525f9096fc5375e24c9d"
PLAYER_ANSWER="${@:2}"

if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWER" ]]; then
    echo "[ OK ]: Chapter (5.3) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (5.3) validation failure!"
exit 1
