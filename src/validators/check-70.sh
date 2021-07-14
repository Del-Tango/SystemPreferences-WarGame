#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L7C0]: Validator

CHECK_SERVICE=`nc localhost 9214 &> /dev/null`
if [ $? -ne 0 ]; then
    echo "[ OK ]: Chapter (7.0) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (7.0) validation failure! ($FAILURES)"
exit 1

