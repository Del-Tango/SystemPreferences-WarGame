#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 7 SETUP

function stage7_chapter0_setup () {
    local FAILURES=0
    if [ -f "${SETUP_CARGO['7.0-listener']}" ]; then
        nohup ${SETUP_CARGO['7.0-listener']} &
        local PROC_PID="$!"
    else
        local FILE_NAME=`basename ${SETUP_CARGO['7.0-listener']}`
        local DIR_PATH=`dirname ${SETUP_CARGO['7.0-listener']}`
        local DIR_NAME=`basename $DIR_PATH`
        local FILE_PATH="${SETUP_DEFAULT['opt-dir']}/${DIR_NAME}/${FILE_NAME}"
        if [ ! -f "$FILE_PATH" ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ WARNING ]: Compromised game structure! (${FILE_NAME}) script not found!"
        else
            ${FILE_PATH} &
            local PROC_PID="$!"
        fi
    fi
    if [ -z "$PROC_PID" ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    echo "$PROC_PID" > ${PID_FILES['7.0']}
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 7.0 setup failure!"
    else
        echo "[ OK ]: Chapter 7.0 setup complete!"
    fi
    return $FAILURES
}

function stage7_chapter1_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 7.1"
    return 0
}

function stage7_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-7"
    stage7_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage7_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "2 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/2) chapters set up!"\
            "Failures detected on level 7! ($FAILURES)"
    else
        echo "[ OK ]: Level 7 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/2) chapters set up!"
    fi
    return $FAILURES
}
