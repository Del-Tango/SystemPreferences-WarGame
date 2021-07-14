#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L0C3]: Validator

EXPECTED_ANSWER_FILEPATH='/bin/picklerick.vuln'
EXPECTED_ANSWER_COMMAND=find\ .\ -name\ picklerick.vuln
PLAYER_ANSWER="${@:2}"
if [ -f "$PLAYER_ANSWER" ]; then
    if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWERT_FILEPATH" ]]; then
        echo "[ OK ]: Chapter (0.3) complete! ($PLAYER_ANSWER)"
        exit 0
    fi
fi
if [[ "$PLAYER_ANSWER" =~ $EXPECTED_ANSWER ]]; then
    echo "[ OK ]: Chapter (0.3) complete! ($PLAYER_ANSWER)"
    exit 0
fi
echo "[ NOK ]: Chapter (0.3) validation failure! ($PLAYER_ANSWER)"
exit 1
