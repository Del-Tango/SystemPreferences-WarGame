#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 7 SETUP

function stage7_chapter0_setup () {
    local FAILURES=0
    ${SETUP_CARGO['7.0-listener']} &
    local PROC_PID="$!"
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
