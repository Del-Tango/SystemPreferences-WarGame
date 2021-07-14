#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L6C2]: Validator

CHECK_SERVICE=`service ssh status &> /dev/null`
if [ $? -ne 0 ]; then
    echo "[ OK ]: Chapter (6.2) complete!"
    exit 0
fi

echo "[ NOK ]: Chapter (6.2) validation failure! ($FAILURES)"
exit 1

