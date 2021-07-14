#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L7C0]: Listener

VALID_ITERATION_COUNT=399
PORT_NUMBER=9214

for count in `seq 1 ${VALID_ITERATION_COUNT}`; do
    nc -l -p $PORT_NUMBER
done

echo "Hmm, crafty little bugger." | nc -l -p $PORT_NUMBER
