#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 8 SETUP

function stage8_install () {
    local FAILURES=0
    local DIR_PATH=`dirname ${SETUP_CARGO['puzzle-maker']}`
    local FILE_NAME=`basename ${SETUP_CARGO['puzzle-maker']}`
    local DIR_NAME=`basename ${DIR_PATH}`
    chown -R "${SETUP_DEFAULT['player-user']}-8" \
        ${SETUP_DEFAULT['opt-dir']}/${DIR_NAME} &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chmod 100 -R \
        "${SETUP_DEFAULT['opt-dir']}/${DIR_NAME}/${FILE_NAME}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chmod 400 -R "${SETUP_DEFAULT['opt-dir']}/${DIR_NAME}/puzzle" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    ${SETUP_DEFAULT['opt-dir']}/${DIR_NAME}/${FILE_NAME} 'server-cli' &> /dev/null &
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-8"
    local USER_BASHRC="${USER_HOME}/${SETUP_DEFAULT['bash-rc']}"
    local TO_APPEND="
trap 'echo <Ctrl-C>?! Are you kidding me? This is the final level, now is not the time for that!' 1 2 3 15 20
nc ${SETUP_DEFAULT['machine-address']} ${SETUP_DEFAULT['machine-port']}
trap - 1 2 3 15 20
exit 0
    "
    echo "$TO_APPEND" >> ${USER_BASHRC}
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Failures detected on Level 8 setup! ($FAILURES)"
    else
        echo "[ OK ]: Level 8 - Locked & Loaded - Puzzle Maker set up!"
    fi
    return $FAILURES
}
