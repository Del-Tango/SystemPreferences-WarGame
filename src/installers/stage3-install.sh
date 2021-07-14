#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 3 SETUP

function stage3_chapter1_setup () {
    echo "[ WARNING ]: Nothing to setup for chapter 3.1"
    return 0
}

function stage3_chapter0_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local DIR_NAME="vim notes\.txt i Esc\-\:wq"
    mkdir "${USER_HOME}/${DIR_NAME}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 3.0 setup failure!"
    else
        echo "[ OK ]: Chapter 3.0 setup complete!"
    fi
    return $FAILURES
}

function stage3_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-3"
    stage3_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage3_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "2 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/2) chapters set up!"\
            "Failures detected on level 3! ($FAILURES)"
    else
        echo "[ OK ]: Level 3 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/2) chapters set up!"
    fi
    return $FAILURES
}
