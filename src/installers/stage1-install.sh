#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# LEVEL 1 SETUP

function stage1_install () {
    local FAILURES=0
    local USER_HOME="${SETUP_DEFAULT['home-dir']}/${SETUP_DEFAULT['player-user']}-1"
    stage1_chapter0_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage1_chapter1_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage1_chapter2_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage1_chapter3_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    stage1_chapter4_setup "$USER_HOME" &> /dev/null
    local FAILURES=$((FAILURES + $?))
    local SUCCESS_COUNT=`echo "5 - ${FAILURES}" | bc`
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: (${SUCCESS_COUNT}/5) chapters set up!"\
            "Failures detected on level 1! ($FAILURES)"
    else
        echo "[ OK ]: Level 1 - Locked & Loaded -"\
            "(${SUCCESS_COUNT}/5) chapters set up!"
    fi
    return $FAILURES
}

function stage1_chapter0_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local FILE_NAME="README"
    local CONTENT="
...told you not to get used to it.
    "
    echo "$CONTENT" > "${USER_HOME}/${FILE_NAME}"
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "mkdir '${USER_HOME}/over there'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    for count in `seq 30`; do
        runuser -l "${SETUP_DEFAULT['player-user']}-1" \
            -c "echo 'Scrambled file!' > '${USER_HOME}/scrambled.${RANDOM}'"
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
        fi
    done
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 1.0 setup failure!"
    else
        echo "[ OK ]: Chapter 1.0 setup complete!"
    fi
    return $FAILURES
}

function stage1_chapter1_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local DIR_PATH="${USER_HOME}/.RnM/PretentiousMOFO"
    local CONTENT="#!/bin/bash"
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "mkdir -p '${DIR_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    local DIR_PATH="${USER_HOME}/.RnM"
    for count in `seq 1 250`; do
        local FILE_PATH="${DIR_PATH}/down-here.${RANDOM}"
        if [ $(($count % 2)) == 0 ]; then
            runuser -l "${SETUP_DEFAULT['player-user']}-1" \
                -c "echo '${CONTENT}' > '${FILE_PATH}'" &> /dev/null
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
            fi
            chmod +x "${FILE_PATH}" &> /dev/null
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
            fi
        elif [ $(($count % 3)) == 0 ]; then
            runuser -l "${SETUP_DEFAULT['player-user']}-1" \
                -c "echo '${CONTENT}' > '${FILE_PATH}'" &> /dev/null
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
            fi
        fi
        runuser -l "${SETUP_DEFAULT['player-user']}-1" \
            -c "touch '${FILE_PATH}'" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
        fi
    done
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 1.1 setup failure!"
    else
        echo "[ OK ]: Chapter 1.1 setup complete!"
    fi
    return $FAILURES
}

function stage1_chapter2_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local MOM_DIR_PATH="${USER_HOME}/.experiment/Mom"
    local DAD_FILE_PATH="${USER_HOME}/.experiment/Dad"
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "mkdir -p '${MOM_DIR_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "touch '${DAD_FILE_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 1.2 setup failure!"
    else
        echo "[ OK ]: Chapter 1.2 setup complete!"
    fi
    return $FAILURES
}

function stage1_chapter3_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local RUG_DIR_PATH="${USER_HOME}/.experiment/.rug"
    local EVIDENCE_DIR_PATH="${USER_HOME}/.experiment/.evidence"
    local CONTENT="Sweep me under the rug!"
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "mkdir -p '${RUG_DIR_PATH}' '${EVIDENCE_DIR_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    for count in `seq 1 13`; do
        local FILE_PATH="${EVIDENCE_DIR_PATH}/evidence.${RANDOM}"
        runuser -l "${SETUP_DEFAULT['player-user']}-1" \
            -c "echo '$CONTENT' > '${FILE_PATH}'" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
        fi
    done
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 1.3 setup failure!"
    else
        echo "[ OK ]: Chapter 1.3 setup complete!"
    fi
    return $FAILURES
}

function stage1_chapter4_setup () {
    local USER_HOME="$1"
    local FAILURES=0
    local FILE_PATH="${USER_HOME}/.experiment/.DFE"
    local CONTENT="DFE starts here! (${USER_HOME}/.expriment)"
    runuser -l "${SETUP_DEFAULT['player-user']}-1" \
        -c "echo '${CONTENT}' > '${FILE_PATH}'" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ NOK ]: Chapter 1.4 setup failure!"
    else
        echo "[ OK ]: Chapter 1.4 setup complete!"
    fi
    return $FAILURES
}

