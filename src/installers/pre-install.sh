#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# PRE INSTALL

function pre_install () {
    local FAILURES=0
    ensure_dependencies_intalled
    local FAILURES=$((FAILURES + $?))
    ensure_game_users
    local FAILURES=$((FAILURES + $?))
    ensure_default_user_shell
    local FAILURES=$((FAILURES + $?))
    ensure_game_file_structure
    local FAILURES=$((FAILURES + $?))
    ensure_file_permissions
    local FAILURES=$((FAILURES + $?))
    set_controller_aliases_for_users
    local FAILURES=$((FAILURES + $?))
    set_user_command_history
    local FAILURES=$((FAILURES + $?))
    set_level_user_login_banners
    local FAILURES=$((FAILURES + $?))
    set_start_chapter
    local FAILURES=$((FAILURES + $?))
    ensure_users_in_home_directory
    local FAILURES=$((FAILURES + $?))
    ensure_sudo_level_users
    local FAILURES=$((FAILURES + $?))
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: Pre install failures detected!"\
            "(${FAILURES})"
    fi
    return $FAILURES
}

# MOVERS & SHAKERS

function move_cargo_into_position () {
    local FAILURES=0
    local SUCCESS=0
    echo "[ INFO ]: Moving ${WARGAME} cargo into position..."
    for cargo_label in ${!SETUP_CARGO[@]}; do
        local DIR_PATH=`dirname "${SETUP_CARGO[$cargo_label]}"`
        local DIR_NAME=`basename "$DIR_PATH"`
        cp -r "$DIR_PATH" "${SETUP_DEFAULT['opt-dir']}" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not move cargo into position!"\
                "(${cargo_label} - ${SETUP_DEFAULT['opt-dir']})"
            local DIR_PATH=
            local DIR_NAME=
            continue
        fi
        local SUCCESS=$((SUCCESS + 1))
        local DIR_PATH=
        local DIR_NAME=
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#SETUP_CARGO[@]}) cargo directories in"\
            "position!"
    else
        echo "[ NOK ]: Could not move cargo in position!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function move_chapter_banners_into_position () {
    local FAILURES=0
    local SUCCESS=0
    for file_path in ${CHAPTER_BANNERS[@]}; do
        cp "$file_path" "${SETUP_DEFAULT['game-dir']}" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not move banner into position!"\
                "(${file_path} - ${SETUP_DEFAULT['game-dir']})"
            continue
        fi
        local FILE_NAME=`basename "$file_path"`
        local NEW_PATH="${SETUP_DEFAULT['game-dir']}/${FILE_NAME}"
        local SUCCESS=$((SUCCESS + 1))
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#CHAPTER_BANNERS[@]}) chapter banners in position!"
    else
        echo "[ NOK ]: Could not move chapter banners in position!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function move_controller_scripts_into_position () {
    local FAILURES=0
    local SUCCESS=0
    for file_path in ${GAME_CONTROLLERS[@]}; do
        cp "$file_path" "${SETUP_DEFAULT['bin-dir']}" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not move controller into position!"\
                "(${file_path} - ${SETUP_DEFAULT['bin-dir']})"
            continue
        fi
        local FILE_NAME=`basename "$file_path"`
        local NEW_PATH="${SETUP_DEFAULT['bin-dir']}/${FILE_NAME}"
        local SUCCESS=$((SUCCESS + 1))
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#GAME_CONTROLLERS[@]}) controllers in position!"
    else
        echo "[ NOK ]: Could not move controllers in position!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function move_validator_scripts_into_position () {
    local FAILURES=0
    local SUCCESS=0
    for file_path in ${CHAPTER_VALIDATORS[@]}; do
        mv "$file_path" "${SETUP_DEFAULT['game-dir']}" &> /dev/null
        if [ $? -ne 0 ]; then
             local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not move validator into position!"\
                "(${file_path} - ${SETUP_DEFAULT['game-dir']})"
            continue
        fi
        local FILE_NAME=`basename "$file_path"`
        local NEW_PATH="${SETUP_DEFAULT['game-dir']}/${FILE_NAME}"
        local SUCCESS=$((SUCCESS + 1))
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#CHAPTER_VALIDATORS[@]}) validators in position!"
    else
        echo "[ NOK ]: Could not move controllers in position!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

# SETTERS

function set_user_command_history () {
    local FAILURES=0
    local SUCCESS=0
    for level_user in ${LEVEL_USERS[@]}; do
        local USER_HOME="${SETUP_DEFAULT['home-dir']}/${level_user}"
        if [ ! -d "$USER_HOME" ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: User HOME directory not found!"\
                "(${level_user} - ${USER_HOME})"
            continue
        fi
        local BASHRC_PATH="${USER_HOME}/${SETUP_DEFAULT['bash-history']}"
        echo "set -o history" >> "${BASHRC_PATH}"
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not set BASH history! (${level_user})"
            continue
        fi
        local SUCCESS=$((SUCCESS + 1))
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: BASH history set for (${SUCCESS}/${#LEVEL_USERS[@]}) users!"
    else
        echo "[ NOK ]: Could not set user BASH history!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function set_controller_aliases_for_users () {
    local FAILURES=0
    local SUCCESS=0
    echo "[ INFO ]: Setting game controller aliases..."
    for level_user in ${LEVEL_USERS[@]}; do
        local USER_HOME="${SETUP_DEFAULT['home-dir']}/${level_user}"
        if [ ! -d "$USER_HOME" ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: User HOME directory not found!"\
                "(${level_user} - ${USER_HOME})"
            continue
        fi
        touch ${SETUP_DEFAULT['bash-rc']} \
            ${SETUP_DEFAULT['bash-aliases']} &> /dev/null
        local CMD="source ${SETUP_DEFAULT['bash-aliases']}"
        echo "$CMD" >> ${USER_HOME}/${SETUP_DEFAULT['bash-rc']}
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not ensure files exist!"\
                "(${SETUP_DEFAULT['bash-rc']} ${SETUP_DEFAULT['bash-aliases']})"
            continue
        fi
        for controller in ${!GAME_CONTROLLERS[@]}; do
            local FILE_NAME=`basename "${GAME_CONTROLLERS[$controller]}"`
            local FILE_PATH="${SETUP_DEFAULT['bin-dir']}/${FILE_NAME}"
            local FORMATTED_RECORD="alias ${controller}='$FILE_PATH'"
            echo "$FORMATTED_RECORD" \
                >> "${USER_HOME}/${SETUP_DEFAULT['bash-aliases']}"
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
                echo "[ NOK ]: Could not set controller alias!"\
                    "(${level_user} - ${controller})"
#           else
#               echo "[ OK ]: Controller alias set!"\
#                   "(${level_user} - ${controller})"
            fi
        done
        local SUCCESS=$((SUCCESS + 1))
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#LEVEL_USERS[@]}) users with controller aliases set!"
    else
        echo "[ NOK ]: Could not set user controller aliases!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function set_level_user_login_banners () {
    local FAILURES=0
    echo "[ INFO ]: Setting level chapter banners..."
    for level_user in ${LEVEL_USERS[@]}; do
        local USER_HOME="${SETUP_DEFAULT['home-dir']}/${level_user}"
        if [ ! -d "${USER_HOME}" ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: No level user directory found! (${USER_HOME})"
            continue
        fi
        local BASH_RC_PATH="${USER_HOME}/${SETUP_DEFAULT['bash-rc']}"
        if [ ! -f "$BASH_RC_PATH" ]; then
            echo "[ WARNING ]: No (.bashrc) file found for game level user"\
                "($level_user)! Building... (${BASH_RC_PATH})"
            touch ${BASH_RC_PATH} &> /dev/null
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
                echo "[ NOK ]: Could not ensure (.bashrc) file exists!"\
                    "Skipping..."
                continue
            fi
        fi
        local USER_LEVEL=`(echo "$level_user" | cut -d'-' -f2)`
        if [[ "$USER_LEVEL" == "${SETUP_DEFAULT['player-user']}" ]]; then
            local USER_LEVEL="0"
        fi
        local LEVEL_CHAPTER_BANNER="${USER_LEVEL}.0"
        if [ -f "${CHAPTER_BANNERS[$LEVEL_CHAPTER_BANNER]}" ]; then
            local CONTENT="
game chapter &> /dev/null
GAME_CHAPTER=\$?
game level &> /dev/null
GAME_LEVEL=\$?
GAME_TAG=\"\${GAME_LEVEL}\"\"\${GAME_CHAPTER}\"
BANNER_DIR='${SETUP_DEFAULT['game-dir']}'
clear; cat \"\${BANNER_DIR}/banner-\${GAME_TAG}.txt\"
"
            echo "$CONTENT" >> "${BASH_RC_PATH}"
            if [ $? -ne 0 ]; then
                local FAILURES=$((FAILURES + 1))
                echo "[ NOK ]: Could not write to file!"\
                    "(${level_user}:${BASH_RC_PATH})"
                continue
            fi
        fi
    done
    local SUCCESS=`echo "${#LEVEL_USERS[@]} - $FAILURES" | bc`
    echo "[ OK ]: (${SUCCESS}/${#LEVEL_USERS[@]}) chapters banners set to user"\
        "login shell. ($FAILURES) failures."
    return $FAILURES
}

function set_chapter_file_permissions () {
    echo "[ INFO ]: Setting chapter file permissions..."
    chmod 666 ${SETUP_DEFAULT['chapter-file']} &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not set chapter file permissions!"
    else
        echo "[ OK ]: Chapter file permissions set!"
    fi
    return $EXIT_CODE
}

function set_start_chapter () {
    local START_CHAPTER="0.0"
    echo "[ INFO ]: Setting game start chapter... (${START_CHAPTER})"
    echo "$START_CHAPTER" > ${SETUP_DEFAULT['chapter-file']}
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not set start chapter!"
    else
        echo "[ OK ]: Start chapter set!"
    fi
    return $EXIT_CODE
}

# ENSURANCE

function ensure_sudo_level_users () {
    local FAILURES=0
    local SUCCESS=0
    adduser "${LEVEL_USERS['6']}" sudo &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    return $FAILURES
}

function ensure_game_users () {
    local FAILURES=0
    local SUCCESS=0
    echo "[ INFO ]: Creating game level user with HOME directory..."
    for game_level in ${!LEVEL_USERS[@]}; do
        check_user_exists "${LEVEL_USERS[$game_level]}"
        if [ $? -eq 0 ]; then
            echo "[ OK ]: User already exists! Skipping..."\
                "(${LEVEL_USERS[$game_level]})"
            continue
        fi
        create_user "${LEVEL_USERS[$game_level]}"
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not create user! (${LEVEL_USERS[$game_level]})"
        else
            local SUCCESS=$((SUCCESS + 1))
        fi
    done
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: (${SUCCESS}/${#LEVEL_USERS[@]}) users spawned!"
    else
        echo "[ NOK ]: Could not spawn level users!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function ensure_file_permissions () {
    local FAILURES=0
    local SUCCESS=0
    chmod +x -R "${SETUP_DEFAULT['installer-dir']}" \
        "${SETUP_DEFAULT['validator-dir']}" \
        "${SETUP_DEFAULT['controller-dir']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Could not add execution permissions!"
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    chmod +r "${SETUP_DEFAULT['chapter-file']}" \
        "${SETUP_DEFAULT['bash-aliases']}" \
        "${SETUP_DEFAULT['bash-rc']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Could not add read permissions!"
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    chmod -w -R "${SETUP_DEFAULT['installer-dir']}" \
        "${SETUP_DEFAULT['validator-dir']}" \
        "${SETUP_DEFAULT['controller-dir']}" \
        "${SETUP_DEFAULT['bash-aliases']}" \
        "${SETUP_DEFAULT['bash-rc']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Could not remove write permissions!"
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    chmod 111 "${GAME_CONTROLLERS['game']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Could not set game controller permissions!"
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    set_chapter_file_permissions
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
    else
        local SUCCESS=$((SUCCESS + 1))
    fi
    if [ $SUCCESS -ne 0 ]; then
        echo "[ OK ]: Permissions modified for (${SUCCESS}/5) file categories!"
    else
        echo "[ NOK ]: Could not modify file permissions!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: (${FAILURES}) failures detected!"
    fi
    return $FAILURES
}

function ensure_game_file_structure () {
    local FAILURES=0
    if [ ! -d ${SETUP_DEFAULT['game-dir']} ]; then
        echo "[ INFO ]: Game global access directory not found! Building..."
        mkdir -p ${SETUP_DEFAULT['game-dir']} &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + $?))
            echo "[ NOK ]: Could not create game dir!"
            return $FAILURES
        fi
    fi
    touch "${SETUP_DEFAULT['chapter-file']}" \
        "${SETUP_DEFAULT['bash-aliases']}" \
        "${SETUP_DEFAULT['bash-rc']}" &> /dev/null
    echo "[ OK ]: Construction complete!"
    echo "[ INFO ]: Shovelling files around..."
    move_controller_scripts_into_position
    local FAILURES=$((FAILURES + $?))
    move_validator_scripts_into_position
    local FAILURES=$((FAILURES + $?))
    move_chapter_banners_into_position
    local FAILURES=$((FAILURES + $?))
    move_cargo_into_position
    local FAILURES=$((FAILURES + $?))
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: WarGame structure setup failures detected!"\
            "(${FAILURES})"
    fi
    return $FAILURES
}

function ensure_users_in_home_directory () {
    local CMD='cd ~'
    local FAILURES=0
    echo "[ INFO ]: Making sure players start in the user HOME directory..."
    for level_user in ${LEVEL_USERS[@]}; do
        local USER_HOME="${SETUP_DEFAULT['home-dir']}/${level_user}"
        if [ ! -d "$USER_HOME" ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: User HOME directory not found! Skipping..."\
                "(${level_user} - ${USER_HOME})"
            continue
        fi
        echo "$CMD" >> "${USER_HOME}/${SETUP_DEFAULT['bash-rc']}"
        local EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            local PLAYER_LVL=`echo "$level_user" | cut -d'-' -f2`
            if [ -z "$PLAYER_LVL" ] || \
                    [[ "$PLAYER_LEVEL" == "${SETUP_DEFAULT['player-user']}" ]]; then
                local PLAYER_LVL="0"
            fi
            echo "[ NOK ]: Could not ensure player starts in the right place"\
                "on level (${PLAYER_LVL})"
        fi
    done
    local SUCCESS=`echo "${#LEVEL_USERS[@]} - $FAILURES" | bc`
    echo "[ OK ]: (${SUCCESS}/${#LEVEL_USERS[@]}) users ensured! (${FAILURES}) failures."
    return $FAILURES
}

function ensure_default_user_shell () {
    echo "[ INFO ]: Setting default user shell..."\
        "(${SETUP_DEFAULT['player-shell']})"
    chsh -s ${SETUP_DEFAULT['player-shell']} \
        ${SETUP_DEFAULT['player-user']} &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not set existing user shell!"\
            "(${SETUP_DEFAULT['player-user']})"
    else
        echo "[ OK ]: Existing user shell set!"\
            "(${SETUP_DEFAULT['player-user']})"
    fi
    return $EXIT_CODE
}

function ensure_dependencies_intalled () {
    local FAILURES=0
    for pkg in ${DEPENDENCIES[@]}; do
        type "$pkg" &> /dev/null
        if [ $? -eq 0 ]; then
            echo "[ OK ]: Package already installed! Skipping... ($pkg)"
            continue
        fi
        echo "[ INFO ]: Intalling dependency... ($pkg)"
        apt-get install -y $pkg &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Dependency installation failure! ($pkg)"
        else
            echo "[ OK ]: Installation complete!"
        fi
    done
    return $FAILURES
}

# CODE DUMP

