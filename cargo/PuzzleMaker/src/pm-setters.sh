#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_log_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File ${RED}$FILE_PATH${RESET} does not exist."
        return 1
    fi
    MD_DEFAULT['log-file']="$FILE_PATH"
    return 0
}

function set_log_lines () {
    local LOG_LINES=$1
    if [ -z "$LOG_LINES" ]; then
        error_msg "Log line value ${RED}$LOG_LINES${RESET} is not a number."
        return 1
    fi
    MD_DEFAULT['log-lines']=$LOG_LINES
    return 0
}

function set_puzzle_game () {
    local DIRECTORY_PATH="$1"
    check_directory_exists "$DIRECTORY_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$DIRECTORY_PATH${RESET} does not exist."
        return 1
    fi
    MD_DEFAULT['puzzle-path']="$DIRECTORY_PATH"
    return 0
}

function set_puzzle_port_number () {
    local PORT_NUMBER=$1
    check_value_is_number $PORT_NUMBER
    if [ $? -ne 0 ]; then
        error_msg "Value ${RED}$PORT_NUMBER${RESET}"\
            "is not a valid port number."
        return 1
    fi
    MD_DEFAULT['puzzle-port']=$PORT_NUMBER
    return 0
}

function set_active_puzzle_directory () {
    local DIRECTORY_PATH="$1"
    check_directory_exists "$DIRECTORY_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$DIRECTORY_PATH${RESET} does not exist."
        return 1
    fi
    MD_DEFAULT['puzzle-dir']="$DIRECTORY_PATH"
    return 0
}

function set_puzzle_playthrough_order () {
    local PLAYTHROUGH_ORDER="$1"
    VALID_ORDERS=( `fetch_valid_puzzle_playthrough_orders` )
    check_item_in_set "$PLAYTHROUGH_ORDER" ${VALID_ORDERS[@]}
    if [ $? -ne 0 ]; then
        error_msg "Invalid puzzle playthrough order"\
            "value ${RED}$PLAYTHROUGH_ORDER${RESET}."
        return 1
    fi
    MD_DEFAULT['puzzle-order']="$PLAYTHROUGH_ORDER"
    return 0
}

