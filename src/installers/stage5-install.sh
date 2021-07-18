#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 5 SETUP

function stage5_chapter0_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 5.0"
    return 0
}

function stage5_chapter1_setup () {
    local FAILURES=0
    nohup echo "Congrats Morty! Now you can progress to the next chapter -"\
        "Oh boy, this is exciting! Press <Ctrl-C> to break the connection"\
        "and type ~$ game submit" | nohup nc -l -p 9191 &
    local EXIT_CODE="$?"
    local PROC_PID="$!"
    if [ $EXIT_CODE -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    echo "$PROC_PID" > "${PID_FILES['5.1']}"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 5.1 setup failure!"
    else
        echo "[ OK ]: Chapter 5.1 setup complete!"
    fi
    return $FAILURES
}

function stage5_chapter2_setup () {
    local FAILURES=0
    local PORT_NUMBER=3162
    nohup echo "Congrats Morty! Consider this your big boy card - now go to"\
        "the next chapter already, there's no time to lose!" | \
        nohup nc -l -p $PORT_NUMBER &
    local EXIT_CODE="$?"
    local PROC_PID="$!"
    if [ $EXIT_CODE -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    echo "$PROC_PID" > "${PID_FILES['5.2']}"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 5.2 setup failure!"
    else
        echo "[ OK ]: Chapter 5.2 setup complete!"
    fi
    return $FAILURES
}

function stage5_chapter3_setup () {
    local FAILURES=0
    cp "${SETUP_DEFAULT['httpd-index']}" "${SETUP_DEFAULT['root-dir']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    cp "${SETUP_DEFAULT['httpd-conf']}" "${SETUP_DEFAULT['etc-dir']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local INDEX_FILE=`basename "${SETUP_DEFAULT['httpd-index']}"`
    local NEW_INDEX_PATH="${SETUP_DEFAULT['root-dir']}/${INDEX_FILE}"
    local CONF_FILE=`basename "${SETUP_DEFAULT['httpd-conf']}"`
    local NEW_CONF_PATH="${SETUP_DEFAULT['etc-dir']}/${CONF_FILE}"
    cd "${SETUP_DEFAULT['root-dir']}" &> /dev/null \
        && nohup busybox httpd -c "${NEW_CONF_PATH}" -p 7345 2> /dev/null \
        && echo "$!" > "${PID_FILES['5.3']}" \
        && cd - &> /dev/null
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 5.3 setup failure!"
    else
        echo "[ OK ]: Chapter 5.3 setup complete!"
    fi
    return $FAILURES
}

function stage5_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-5"
    stage5_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage5_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage5_chapter2_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage5_chapter3_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "4 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/4) chapters set up!"\
            "Failures detected on level 5! ($FAILURES)"
    else
        echo "[ OK ]: Level 5 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/4) chapters set up!"
    fi
    return $FAILURES
}
