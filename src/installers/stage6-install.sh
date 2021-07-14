#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 6 SETUP

function stage6_chapter0_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 6.0"
    return 0
}

function stage6_chapter1_setup () {
    local FAILURES=0
    ensure_ssh_service_offline
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 6.1 setup failure! ($EXIT_CODE)"
    else
        echo "[ OK ]: Chapter 6.1 setup complete!"
    fi
    return $FAILURES
}

function stage6_chapter2_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 6.2"
    return 0
}

function stage6_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-6"
    stage6_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage6_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage6_chapter2_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "3 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/3) chapters set up!"\
            "Failures detected on level 6! ($FAILURES)"
    else
        echo "[ OK ]: Level 6 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/3) chapters set up!"
    fi
    return $FAILURES
}
