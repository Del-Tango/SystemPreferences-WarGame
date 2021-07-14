#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 4 SETUP

function stage4_chapter0_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 4.0"
    return 0
}

function stage4_chapter1_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 4.1"
    return 0
}

function stage4_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-4"
    stage4_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage4_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "2 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/2) chapters set up!"\
            "Failures detected on level 4! ($FAILURES)"
    else
        echo "[ OK ]: Level 4 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/2) chapters set up!"
    fi
    return $FAILURES
}
