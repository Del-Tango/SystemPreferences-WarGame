#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L6C0]: Validator

EXPECTED_ANSWER="service ssh status"
PLAYER_ANSWER="${@:2}"

if [[ "$PLAYER_ANSWER" == "$EXPECTED_ANSWER" ]]; then
    echo "[ OK ]: Chapter (6.0) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (6.0) validation failure!"
exit 1

# CODE DUMP

#   USER_HOME='/home/Ghost-6'
#   BASH_HISTORY="${USER_HOME}/.bash_history"
#   HISTORY_CONTENT=`cat ${BASH_HISTORY}`
#   EXPECTED_COMMAND='service ssh status'
#   CHECK=`echo "$HISTORY_CONTENT" | grep "${EXPECTED_COMMAND}"`

#   if [ $? -eq 0 ]; then
#       echo "[ OK ]: Chapter (6.0) complete!"
#       exit 0
#   fi

#   echo "[ NOK ]: Chapter (6.0) validation failure! ($FAILURES)"
#   exit 1
