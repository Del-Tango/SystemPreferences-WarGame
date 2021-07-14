#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# System Preferences - War Game Kit

declare -A SETUP_DEFAULT
declare -A SETUP_INSTALLERS
declare -A SETUP_CARGO
declare -A CHAPTER_VALIDATORS
declare -A CHAPTER_BANNERS
declare -A GAME_CONTROLLERS
declare -A LEVEL_USERS
declare -A USER_PASSWORDS
declare -A PID_FILES

GAME_KIT_DIR="$(
    cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd
)"
CONFIG_FILE_PATH="${GAME_KIT_DIR}/conf/setup.conf"

if [ -r "$CONFIG_FILE_PATH" ]; then
    source "$CONFIG_FILE_PATH"
else
    echo "[ WARNING ]: No config file found! ($CONFIG_FILE_PATH)"
    return 1
fi

for installer in ${!SETUP_INSTALLERS[@]}; do
    if [ ! -f "${SETUP_INSTALLERS[$installer]}" ]; then
        echo "[ WARNING ]: Installer not found!"\
            "($installer - "${SETUP_INSTALLERS[$installer]}")"
        continue
    fi
    source "${SETUP_INSTALLERS[$installer]}"
done

function setup_game_kit () {
    local FAILURES=0
    echo "[ ${WARGAME} ]: Wargame kit setup..."
    pre_install
    local FAILURES=$((FAILURES + $?))
    echo "[ INFO ]: Level environment setup..."
    stage0_install
    local FAILURES=$((FAILURES + $?))
    stage1_install
    local FAILURES=$((FAILURES + $?))
    stage2_install
    local FAILURES=$((FAILURES + $?))
    stage3_install
    local FAILURES=$((FAILURES + $?))
    stage4_install
    local FAILURES=$((FAILURES + $?))
    stage5_install
    local FAILURES=$((FAILURES + $?))
    stage6_install
    local FAILURES=$((FAILURES + $?))
    stage7_install
    local FAILURES=$((FAILURES + $?))
    stage8_install
    local FAILURES=$((FAILURES + $?))
    post_install
    local FAILURES=$((FAILURES + $?))
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: Setup failures detected! ($FAILURES)"
    fi
    return $FAILURES
}

setup_game_kit

# [ NOTE ]: Comment when not debugging
#   read -p 'Tear Down? Y/N> ' ANSWER
#   case "$ANSWER" in
#       'y')
#           tear_down
#           ;;
#   esac

exit $?
