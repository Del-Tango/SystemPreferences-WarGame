#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L6C1]: Validator

CHECK_SERVICE=`service ssh status &> /dev/null`
if [ $? -eq 0 ]; then
    echo "[ OK ]: Chapter (6.1) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (6.1) validation failure! ($FAILURES)"
exit 1

# CODE DUMP

# FAILURES=0
# USER_HOME='/home/Ghost-6'
# BASH_HISTORY="${USER_HOME}/.bash_history"
# HISTORY_CONTENT=`cat ${BASH_HISTORY}`
# EXPECTED_COMMAND='service ssh start && echo $?'
#   CHECK_HISTORY=`echo "$HISTORY_CONTENT" | grep "${EXPECTED_COMMAND}"`
#   if [ $? -ne 0 ]; then
#       FAILURES=$((FAILURES + 1))
#   fi


