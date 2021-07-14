#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L1C0]: Validator

USER_DIR='/home/Ghost-1'
TARGET_DIR="${USER_DIR}/over there"
SCRAMBLED_FILES=`ls "$TARGET_DIR" | egrep '^scrambled\.'*`
SCRAMBLED_NO=`ls "$TARGET_DIR" | egrep '^scrambled\.'* | wc -l`
SCRAMBLED_LEFTOVERS=`ls "$USER_DIR" | egrep '^scrambled\.'*`
LEFTOVERS_NO=`ls "$USER_DIR" | egrep '^scrambled\.'* | wc -l`

if [ $LEFTOVERS_NO -eq 0 ] \
        && [ ! -z "$SCRAMBLED_NO" ] \
        && [ $SCRAMBLED_NO -eq 30 ]; then
    echo "[ OK ]: Chapter (1.0) complete! ($PLAYER_ANSWER)"
    exit 0
fi
echo "[ NOK ]: Chapter (1.0) validation failure! ($PLAYER_ANSWER)"
exit 1

