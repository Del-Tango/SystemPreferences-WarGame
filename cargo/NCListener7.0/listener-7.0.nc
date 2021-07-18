#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L7C0]: Listener

VALID_ITERATION_COUNT=399
PORT_NUMBER=9214
USER_NAME='Ghost-7'

for count in `seq 1 ${VALID_ITERATION_COUNT}`; do
    runuser -l "$USER_NAME" -c "nc -l -p $PORT_NUMBER"
done

runuser -l "$USER_NAME" -c "echo 'Hmm, crafty little bugger.' | nc -l -p $PORT_NUMBER"

