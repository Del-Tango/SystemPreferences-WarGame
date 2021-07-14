#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L7C1]: Validator

PORT_NUMBER=$2
EXPECTED_ITERATIONS=400
ITERATIONS=0
CONNECTIONS=0

for count in `seq 1 $EXPECTED_ITERATIONS`; do
    echo "[ INFO ]: Cnx ($count)..."
    nc localhost $PORT_NUMBER &> /dev/null &
    if [ $? -eq 0 ]; then
        CONNECTIONS=$((CONNECTIONS + 1))
    fi
done

CHECK_SERVICE=`nc localhost $PORT_NUMBER &> /dev/null`
if [ $? -ne 0 ] && [ $CONNECTIONS -ne 0 ]; then
    echo "[ OK ]: Chapter (7.1) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (7.1) validation failure! ($FAILURES)"
exit 1

