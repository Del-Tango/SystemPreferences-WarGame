#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# GENERAL

function verify_puzzle_server_port () {
    check_value_is_number ${MD_DEFAULT['puzzle-port']}
    return $?
}

function verify_behaviours_ok () {
    if [ ${#PM_BEHAVIOURS_OK[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

function verify_behaviours_nok () {
    if [ ${#PM_BEHAVIOURS_NOK[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

function verify_answer_types () {
    if [ ${#PM_ANSWER_TYPES[@]} -eq 0 ]; then
        return 1
    fi
    return 0
}

function verify_loaded_puzzle () {
    check_directory_exists "${MD_DEFAULT['puzzle-path']}"
    return $?
}

function perform_puzzle_server_verifications () {
    verify_puzzle_server_port
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} ${RED}server port${RESET} verifications failed."
        return $EXIT_CODE
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} ${GREEN}server port${RESET} verifications passed."
    fi
    verify_behaviours_ok
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} ${RED}OK behaviour set${RESET}"\
            "verifications failed (${RED}$EXIT_CODE${RESET})."
        return $EXIT_CODE
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} ${GREEN}OK behaviour set${RESET}"\
            "verifications passed."
    fi
    verify_behaviours_nok
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} ${RED}NOK behaviour set${RESET}"\
            "verifications failed (${RED}$EXIT_CODE${RESET})."
        return $EXIT_CODE
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} ${GREEN}NOK behaviour set${RESET}"\
            "verifications passed."
    fi
    verify_answer_types
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} ${RED}player answer type set${RESET}"\
            "verifications failed (${RED}$EXIT_CODE${RESET})."
        return $EXIT_CODE
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} ${GREEN}player answer type set${RESET}"\
            "verifications passed."
    fi
    verify_loaded_puzzle
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} ${RED}loaded puzzle${RESET}"\
            "verifications failed (${RED}$EXIT_CODE${RESET})."
        return $EXIT_CODE
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} ${GREEN}loaded puzzle${RESET}"\
            "verifications passed."
    fi
    done_msg "All ${GREEN}$SCRIPT_NAME${RESET} preliminary"\
        "verifications passed."
    return 0
}

function reset_score () {
    PM_SUCCESS_COUNT=0
    PM_FAILURE_COUNT=0
    PM_FAILED_LVL=0
    PM_FAILED_PZL=0
}

function mark_current_level_failure () {
    PM_FAILED_LVL=1
    return 0
}

function mark_current_level_success () {
    PM_FAILED_LVL=0
    return 0
}

function increment_failure_count () {
    PM_FAILURE_COUNT=$((PM_FAILURE_COUNT + 1))
    return 0
}

function increment_success_count () {
    PM_SUCCESS_COUNT=$((PM_SUCCESS_COUNT + 1))
    return 0
}

function sort_alphanumerically () {
    local ITEMS="$@"
    echo -n > ${MD_DEFAULT['tmp-file']}
    echo $ITEMS > ${MD_DEFAULT['tmp-file']}
    sort ${MD_DEFAULT['tmp-file']}
    EXIT_CODE=$?
    echo -n > ${MD_DEFAULT['tmp-file']}
    return $EXIT_CODE
}

function edit_file () {
    local FILE_PATH="$1"
    ${MD_DEFAULT['file-editor']} $FILE_PATH
    return $?
}

function untrap_persistent_menu_return_signal_sigint () {
    trap - SIGINT
    return $?
}

function trap_persistent_menu_return_signal_sigint () {
    local MESSAGE="$@"
    trap_menu_return_signals "'echo $MESSAGE; return 0'" "SIGINT"
    return $?
}

function trap_single_menu_return_signal_sigint () {
    local MESSAGE="$@"
    trap_menu_return_signals "'trap - SIGINT; echo $MESSAGE; return 0'" "SIGINT"
    return $?
}

function trap_menu_return_signals () {
    local ACTIONS="$1"
    local SIGNALS="$2"
    trap $ACTIONS $SIGNALS
    return $?
}


