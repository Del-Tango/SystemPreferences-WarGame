#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 0 SETUP

function stage0_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}"
    stage0_chapter0_setup "${USER_HOME}" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage0_chapter1_setup "${USER_HOME}" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage0_chapter2_setup "${USER_HOME}" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage0_chapter3_setup &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage0_chapter4_setup "${USER_HOME}" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage0_chapter5_setup "${USER_HOME}" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    chown -R ${SETUP_DEFAULT['player-user']} ${USER_HOME} &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "6 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/6) chapters set up!"\
            "Failures detected on level 0! ($FAILURES)"
    else
        echo "[ OK ]: Level 0 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/6) chapters set up!"
    fi
    return $FAILURES
}

function stage0_chapter4_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local DIR_NAME='.one@ of\`\\\\ the'
    local DIR_PATH="${USER_HOME}/${DIR_NAME}"
    local STASH="Giant Seeds"
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "mkdir -p '${DIR_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local RESERVED_FILE_NAME=""
    for count in `seq 1 100`; do
        local FILE_NAME="one-of-the-files.${RANDOM}"
        local FILE_PATH="${DIR_PATH}/${FILE_NAME}"
        if [ $count -eq 50 ]; then
            local RESERVED_FILE_NAME="${FILE_NAME}"
        fi
        runuser -l "${SETUP_DEFAULT['player-user']}" \
            -c "touch '$FILE_PATH'" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
        fi
    done
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "cd '${DIR_PATH}' && echo '${STASH}' > '${RESERVED_FILE_NAME}' && cd -" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 0.4 setup failure!"
    else
        echo "[ OK ]: Chapter 0.4 setup"
    fi
    return $FAILURES
}

function stage0_chapter0_setup () {
    local USER_HOME="$1"
    local FILE_NAME="README"
    local CONTENT="
Hello Friend,


As a gesture of good faith, and reward for managing to read this file, somehow...
We're going to give you a helping hand with this one, but don't get used to it!

What you have to do is first display the contents of the root (/) directory. You
can do this with the help of the (ls) command.

[ EXAMPLE ]:
    ~$ ls /
       bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

Select the command output with your mouse, and copy using the keys <CTRL-SHIFT-C>.
Then write the command (game submit) followed by what you just copied, which you
can paste using the <CTRL-SHIFT-V> key bind. Make sure to quote the answer for
this level.

[ EXAMPLE ]:
    ~$ game submit 'bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var'


Excellent Regards,
The Alveare Solutions #!/Society -x
    "
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "echo '$CONTENT' > '${USER_HOME}/${FILE_NAME}'"
    if [ $? -ne 0 ]; then
        echo "[ NOK ]: Chapter 0.0 setup failure!"
        return 1
    else
        echo "[ OK ]: Chapter 0.0 setup"
    fi
    return 0

}

function stage0_chapter1_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local FILE_NAME="ordinary-every-day-regular-file"
    echo "I'm just a regular, every day, normal mothafucka!" \
        > "${SETUP_DEFAULT['etc-dir']}/${FILE_NAME}"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Chapter 0.1 setup failure!"
    else
        echo "[ OK ]: Chapter 0.1 setup"
    fi
    return $FAILURES
}

function stage0_chapter2_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local FILE_NAME=".hidden"
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "echo 'This file was hidden by the power and will of the UNIX Gods.' > '${USER_HOME}/${FILE_NAME}'"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Chapter 0.2 setup failure!"
    else
        echo "[ OK ]: Chapter 0.2 setup"
    fi
    return $FAILURES
}

function stage0_chapter3_setup () {
    local FAILURES=0
    local FILE_NAME="picklerick.vuln"
    cp "${SETUP_DEFAULT['player-shell']}" \
        "${SETUP_DEFAULT['bin-dir']}/${FILE_NAME}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    chmod +x "${SETUP_DEFAULT['bin-dir']}/${FILE_NAME}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 0.3 setup failure!"
    else
        echo "[ OK ]: Chapter 0.3 setup"
    fi
    return $FAILURES
}

function stage0_chapter5_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local DIR_PATH="${USER_HOME}/pile/of/junk"
    local STASH="Giant Seeds (+10xp)"
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "mkdir -p ${DIR_PATH}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local RESERVED_FILE_PATH=
    for count in `seq 1 500`; do
        local FILE_PATH="${DIR_PATH}/one-of-the-files.${RANDOM}"
        if [ $count -eq 250 ]; then
            local RESERVED_FILE_PATH="${FILE_PATH}"
        fi
        runuser -l "${SETUP_DEFAULT['player-user']}" \
            -c "touch '$FILE_PATH'" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
        fi
    done
    runuser -l "${SETUP_DEFAULT['player-user']}" \
        -c "echo '${STASH}' > '${RESERVED_FILE_PATH}'"
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 0.5 setup failure!"
    else
        echo "[ OK ]: Chapter 0.5 setup"
    fi
    return $FAILURES
}

