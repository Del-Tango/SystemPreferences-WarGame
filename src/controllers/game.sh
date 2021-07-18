#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# GAME CONTROLLER (System Preferences)

declare -A SETUP_DEFAULT
declare -A SETUP_INSTALLERS
declare -A SETUP_CARGO
declare -A CHAPTER_VALIDATORS
declare -A CHAPTER_BANNERS
declare -A GAME_CONTROLLERS
declare -A LEVEL_USERS
declare -A USER_PASSWORDS
declare -A PID_FILES

CONFIG_FILE_PATH="/etc/.g.conf"

if [ ! -f "$CONFIG_FILE_PATH" ]; then
    echo "[ WARNING ]: No config file found!"
    exit 1
else
    source $CONFIG_FILE_PATH
fi

# FETCHERS

function fetch_current_game_level () {
    local CURRENT_CHAPTER="`cat ${SETUP_DEFAULT['chapter-file']}`"
    local C_LEVEL_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f1`
    if [ -z "$C_LEVEL_NO" ]; then
        return 1
    fi
    echo "$C_LEVEL_NO"
    return $?
}

function fetch_current_game_chapter () {
    local CURRENT_CHAPTER="`cat ${SETUP_DEFAULT['chapter-file']}`"
    local C_CHAPTER_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f2`
    if [ -z "$C_CHAPTER_NO" ]; then
        return 1
    fi
    echo "$C_CHAPTER_NO"
    return $?
}

# CHECKERS

function check_next_chapter_exists () {
    local CURRENT_CHAPTER="$1"
    local C_CHAPTER_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f2`
    local C_LEVEL_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f1`
    if [[ "$C_CHAPTER_NO" == "0" ]]; then
        local N_CHAPTER_NO=1
    else
        local N_CHAPTER_NO=`echo "$C_CHAPTER_NO + 1" | bc`
    fi
    local NEXT_TAG="${C_LEVEL_NO}.${N_CHAPTER_NO}"
    for tag in ${!CHAPTER_BANNERS[@]}; do
        if [[ "$NEXT_TAG" == "$tag" ]]; then
            return 0
        fi
    done
    return 1
}

function check_chapter_file_content () {
    local FILE_LINES=`cat "${SETUP_DEFAULT['chapter-file']}" | wc -l`
    if [[ "$FILE_LINES" != "1" ]]; then
        return 1
    fi
    return 0
}

function check_chapter_file_exists () {
    if [ ! -f ${SETUP_DEFAULT['chapter-file']} ]; then
        return 1
    fi
    return 0
}

function check_next_level_exists () {
    local CURRENT_LEVEL="$1"
    local C_LEVEL_NO=`echo "$CURRENT_LEVEL" | cut -d'.' -f1`
    local N_LEVEL_NO=`echo "$C_LEVEL_NO + 1" | bc`
    local NEXT_TAG="${N_LEVEL_NO}.0"
    for tag in ${!CHAPTER_BANNERS[@]}; do
        if [[ "$NEXT_TAG" == "$tag" ]]; then
            return 0
        fi
    done
    return 1
}

# VALIDATORS

function validate_chapter_file () {
    local FAILURES=0
    check_chapter_file_exists
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        local FAILURES=$((FAILURE + 1))
        echo "[ ERROR ]: Chapter file does not exist!"
    fi
    check_chapter_file_content
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        local FAILURES=$((FAILURE + 1))
        echo "[ ERROR ]: Invalid chapter file content!"
    fi
    return $FAILURES
}

# UPDATERS

function update_chapter_file () {
    local NEW_TAG="$1"
    echo "$NEW_TAG" > ${SETUP_DEFAULT['chapter-file']}
    return $?
}

# ENSURANCE

function ensure_chapter_state_8_0 () {
    CHECK=`ps -aux | grep -e 'puzzle-maker' | \
        grep -e "${LEVEL_USERS['8']}" | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage8']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage8_chapter0_setup &> /dev/null &
    return $?
}

function ensure_chapter_state_2_0 () {
    CHECK=`ps -aux | grep -e 'FriendlyEnterpriseDebugger-Backdoor.sh' | \
        grep -e "${LEVEL_USERS['2']}" | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage2']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage2_chapter0_setup &> /dev/null
    return $?
}

function ensure_chapter_state_2_1 () {
    CHECK=`ps -aux | grep -e 'FED-Blocker.sh' | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage2']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage2_chapter1_setup &> /dev/null
    return $?
}

function ensure_chapter_state_5_1 () {
    CHECK=`ps -aux | grep -e '9191' | grep -e 'nc' | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage5']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage5_chapter1_setup &> /dev/null
    return $?
}

function ensure_chapter_state_5_2 () {
    CHECK=`ps -aux | grep -e '3162' | grep -e 'nc' | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage5']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage5_chapter2_setup &> /dev/null
    return $?
}

function ensure_chapter_state_5_3 () {
    CHECK=`ps -aux | grep '7345' | grep 'busybox' | grep 'httpd' | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage5']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage5_chapter3_setup &> /dev/null
    return $?
}

function ensure_chapter_state_7_0 () {
    CHECK=`ps -aux | grep 'listener-7.0.nc' | grep -v ' Z '`
    if [ ! -z "$CHECK" ]; then
        return 0
    fi
    local INSTALLER_FILE=`basename "${SETUP_INSTALLERS['stage7']}"`
    source "${SETUP_DEFAULT['game-dir']}/${INSTALLER_FILE}"
    stage7_chapter0_setup &> /dev/null
    return $?
}

function ensure_chapter_state () {
    local CHAPTER_TAG="$1"
    local EXIT_CODE=0
    case "$CHAPTER_TAG" in
        '2.0')
            ensure_chapter_state_2_0
            local EXIT_CODE=$?
            ;;
        '2.1')
            ensure_chapter_state_2_1
            local EXIT_CODE=$?
            ;;
        '5.1')
            ensure_chapter_state_5_1
            local EXIT_CODE=$?
            ;;
        '5.2')
            ensure_chapter_state_5_2
            local EXIT_CODE=$?
            ;;
        '5.3')
            ensure_chapter_state_5_3
            local EXIT_CODE=$?
            ;;
        '7.0')
            ensure_chapter_state_7_0
            local EXIT_CODE=$?
            ;;
        '8.0')
            ensure_chapter_state_8_0
            local EXIT_CODE=$?
            ;;
    esac
    return $EXIT_CODE
}

# GENERAL

function go_to_next_level () {
    local CURRENT_CHAPTER="$1"
    local C_LEVEL_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f1`
    local N_LEVEL_NO=`echo "$C_LEVEL_NO + 1" | bc`
    local NEW_TAG="${N_LEVEL_NO}.0"
    local N_LEVEL_USER="${SETUP_DEFAULT['player-user']}-${N_LEVEL_NO}"
    local N_LEVEL_PASS="${USER_PASSWORDS[${N_LEVEL_USER}]}"
    if [ -z "$N_LEVEL_PASS" ]; then
        echo "[ ERROR ]: Could not find next level password!"\
            "(${CURRENT_CHAPTER} -> ${NEW_TAG})"
        return 1
    fi
    ensure_chapter_state "$NEW_TAG"
    if [ $? -ne 0 ]; then
        read -p "[ WARNING ]: Could not ensure chapter state!"\
            "Press any key to continue -" ANSWER
    fi
    update_chapter_file "$NEW_TAG"
    if [ $? -ne 0 ]; then
        echo "[ ERROR ]: Could not update level chapter!"
        return 2
    fi
    while :; do
        echo "[ OK ]: The password for the next level is - ${N_LEVEL_PASS}"
        su ${N_LEVEL_USER}
        if [ $? -ne 0 ]; then
            read -p "Invalid password! Try again? Y/N> " ANSWER
            case "$ANSWER" in
                y|Y|yes|Yes|YES)
                    continue
                    ;;
                *)
                    update_chapter_file "$CURRENT_CHAPTER"
                    ;;
            esac
        fi; break
    done
    return $?
}

function go_to_next_chapter () {
    local CURRENT_CHAPTER="$1"
    local C_CHAPTER_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f2`
    local C_LEVEL_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f1`
    local N_CHAPTER_NO=`echo "$C_CHAPTER_NO + 1" | bc`
    local NEW_TAG="${C_LEVEL_NO}.${N_CHAPTER_NO}"
    ensure_chapter_state "$NEW_TAG"
    if [ $? -ne 0 ]; then
        read -p "[ WARNING ]: Could not ensure chapter state!"\
            "Press any key to continue -" ANSWER
    fi
    update_chapter_file "$NEW_TAG"
    if [ $? -ne 0 ]; then
        echo "[ ERROR ]: Could not update level chapter!"
        return 1
    fi
    local BANNER_FILE=`basename ${CHAPTER_BANNERS[${NEW_TAG}]}`
    local BANNER_PATH="${SETUP_DEFAULT['game-dir']}/${BANNER_FILE}"
    clear; cat "${BANNER_PATH}"
    return $?
}

# ACTIONS

function action_skip_to_chapter () {
    local CHAPTER_NO="$3"
    local C_LEVEL_NO=`fetch_current_game_level`
    local NEW_TAG="${C_LEVEL_NO}.${CHAPTER_NO}"
    for tag in ${!CHAPTER_BANNERS[@]}; do
        if [[ "$NEW_TAG" == "$tag" ]]; then
            local BANNER_FILE=`basename ${CHAPTER_BANNERS[${NEW_TAG}]}`
            local BANNER_PATH="${SETUP_DEFAULT['game-dir']}/${BANNER_FILE}"
            update_chapter_file "$NEW_TAG"
            clear; cat "${BANNER_PATH}"
            return $?
        fi
    done
    return 1
}

function action_submit_ok () {
    local TAG=`cat ${SETUP_DEFAULT['chapter-file']}`
    check_next_chapter_exists "`cat ${SETUP_DEFAULT['chapter-file']}`" $@
    if [ $? -eq 0 ]; then
        read -p '
[ OK ]: Way to go Morty! Chapter complete! Press any key to continue -' ANSWER
        go_to_next_chapter $@
        return $?
    fi
    check_next_level_exists "`cat ${SETUP_DEFAULT['chapter-file']}`" $@
    if [ $? -eq 0 ]; then
        if [[ "$TAG" == '2.1' ]]; then
            echo "
OMG, You're right Morty! I totally forgot, you cant renice processes in Docker
containers, and you're playing in one of those right now... My bad, I'm sorry
for designing it this way.

But aren't you glad you learned about process priority Morty? It's like really
important stuff, it will help you a lot in the long run, trust me."
        fi
        read -p '
[ OK ]: Way to go Morty! Level complete! Press any key to continue -' ANSWER
        go_to_next_level $@
        return $?
    fi
    return 1
}

function action_skip_to_level () {
    local LEVEL_NO="$3"
    local NEW_TAG="${LEVEL_NO}.0"
    for tag in ${!CHAPTER_BANNERS[@]}; do
        if [[ "$NEW_TAG" == "$tag" ]]; then
            if [[ "$LEVEL_NO" == "0" ]]; then
                local N_LEVEL_USER="${SETUP_DEFAULT['player-user']}"
            else
                local N_LEVEL_USER="${SETUP_DEFAULT['player-user']}-${LEVEL_NO}"
            fi
            update_chapter_file "$NEW_TAG"
            echo; echo "[ INFO ]: Skipping to level ($LEVEL_NO)..."
            su "$N_LEVEL_USER"
            return $?
        fi
    done
    echo "[ NOK ]: Invalid level! ($LEVEL_NO)"
    return 1
}

function action_submit_nok () {
    echo "
[ NOK ]: You're going to have to do better than that, Morty!
    "
    return $?
}

# HANDLERS

function handle_action_submit () {
    local CURRENT_CHAPTER="`cat ${SETUP_DEFAULT['chapter-file']}`"
    local VALIDATOR_FILE=`basename ${CHAPTER_VALIDATORS[${CURRENT_CHAPTER}]}`
    local VALIDATOR_PATH="${SETUP_DEFAULT['game-dir']}/${VALIDATOR_FILE}"
    if [ ! -f ${VALIDATOR_PATH} ]; then
        echo "[ WARNING ]: Game tampering detected! Missing validator script - Terminating."
        exit 3
    fi
    ${VALIDATOR_PATH} $@ &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        action_submit_nok
    else
        action_submit_ok "${CURRENT_CHAPTER}"
    fi
    return $EXIT_CODE
}

function handle_action_level () {
    local CURRENT_CHAPTER="`cat ${SETUP_DEFAULT['chapter-file']}`"
    local C_LEVEL_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f 1`
    if [ -z "$C_LEVEL_NO" ]; then
        local C_LEVEL_NO=0
    fi
    echo "
[ INFO ]: Current game level is ($C_LEVEL_NO)
    "
    return $C_LEVEL_NO
}

function handle_action_chapter () {
    local CURRENT_CHAPTER="`cat ${SETUP_DEFAULT['chapter-file']}`"
    local C_CHAPTER_NO=`echo "$CURRENT_CHAPTER" | cut -d'.' -f 2`
    if [ -z "$C_CHAPTER_NO" ]; then
        local C_CHAPTER_NO=0
    fi
    echo "
[ INFO ]: Current level chapter is ($C_CHAPTER_NO)
    "
    return $C_CHAPTER_NO
}

function handle_action_skip () {
    local TARGET="$2"
    case "$TARGET" in
        'level')
            action_skip_to_level $@
            ;;
        'chapter')
            action_skip_to_chapter $@
            ;;
        *)
            display_help
            return 1
            ;;
    esac
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ WARNING ]: Errors detected un game action skip! ($EXIT_CODE)"
    fi
    return $EXIT_CODE
}

function handle_action_help () {
    display_help
    return $?
}

# DISPLAY

function display_help () {
    local SCRIPT_NAME=`basename $0`
    cat <<EOF
    ___________________________________________________________________________

     *               *  System Preferences * Game Controller  *              *
    _________________________________________________________v.FFxSky__________
                       Regards, the Alveare Solutions society

    help      Display this message.
    level     Display current level.
    chapter   Display current level chapter.
    skip      Skip to level or chapter. Available values (level <NO> | chapter <NO>).
    submit    Continue game story. If the level requires it, it can receive any
              type of input data.

    [ EXAMPLE ]: Skip to chapter
        ./${SCRIPT_NAME} skip chapter 3

    [ EXAMPLE ]: Skip to level
        ./${SCRIPT_NAME} skip level 3

    [ EXAMPLE ]: Submit level with data
        ./${SCRIPT_NAME} submit <required-data>

    [ EXAMPLE ]: Submit level
        ./${SCRIPT_NAME} submit

    [ EXAMPLE ]:Check current level
        ./${SCRIPT_NAME} level

    [ EXAMPLE ]:Check current chapter
        ./${SCRIPT_NAME} chapter

EOF
    return $?
}

# MISCELLANEOUS

validate_chapter_file # &> /dev/null
if [ $? -ne 0 ]; then
    echo "[ WARNING ]: Game tampering detected! Invalid chapter file - Terminating."
    exit 2
fi

for opt in $@; do
    case "$opt" in
        'help')
            handle_action_help $@
            ;;
        'skip')
            handle_action_skip $@
            ;;
        'level')
            handle_action_level $@
            ;;
        'chapter')
            handle_action_chapter $@
            ;;
        'submit')
            handle_action_submit $@
            ;;
        *)
            handle_action_help $@
            exit 1
            ;;
    esac
    EXIT_CODE=$?
    break
done

exit $EXIT_CODE
