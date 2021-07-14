#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# COMPUTERS

function compute_puzzle_segment_single_mode () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    EXPECTED=`fetch_segment_instruction_expected "$INSTRUCTION_SET"`
    if [[ "$PLAYER_ANSWER" == "$EXPECTED" ]]; then
        compute_puzzle_segment_single_mode_ok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    else
        compute_puzzle_segment_single_mode_nok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    fi
    return $?
}

function compute_puzzle_segment_multi_mode () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    EXPECTED=`fetch_segment_instruction_expected "$INSTRUCTION_SET"`
    VALID_INPUT=( `echo "$EXPECTED" | tr ',' ' '` )
    if [[ "$PLAYER_ANSWER" == "$EXPECTED" ]]; then
        compute_puzzle_segment_multi_mode_ok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    else
        compute_puzzle_segment_multi_mode_nok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    fi
    return $?
}

function compute_puzzle_segment_single_in () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    EXPECTED=`fetch_segment_instruction_expected "$INSTRUCTION_SET"`
    VALID_INPUT=( `echo "$EXPECTED" | tr ',' ' '` )
    check_item_in_set "$PLAYER_ANSWER" ${VALID_INPUT[@]}
    if [ $? -ne 0 ]; then
        compute_puzzle_segment_single_in_nok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
        return $?
    fi
    compute_puzzle_segment_single_in_ok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    return $?
}

function compute_puzzle_segment_multi_in () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    EXPECTED=`fetch_segment_instruction_expected "$INSTRUCTION_SET"`
    VALID_INPUT=( `echo "$EXPECTED" | tr ',' ' '` )
    for word in $PLAYER_ANSWER; do
        check_item_in_set "$word" ${VALID_INPUT[@]}
        if [ $? -ne 0 ]; then
            continue
        fi
        compute_puzzle_segment_multi_in_ok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
        return $?
    done
    compute_puzzle_segment_multi_in_nok \
            "$PLAYER_ANSWER" "$INSTRUCTION_SET"
    return $?
}

function compute_puzzle_segment_instruction_set () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    ANSWER_TYPE=`fetch_segment_instruction_answer_type "$INSTRUCTION_SET"`
    case "$ANSWER_TYPE" in
        'single-mode')
            compute_puzzle_segment_single_mode \
                "$PLAYER_ANSWER" "$INSTRUCTION_SET"
            ;;
        'multi-mode')
            compute_puzzle_segment_multi_mode \
                "$PLAYER_ANSWER" "$INSTRUCTION_SET"
            ;;
        'single-in')
            compute_puzzle_segment_single_in \
                "$PLAYER_ANSWER" "$INSTRUCTION_SET"
            ;;
        'multi-in')
            compute_puzzle_segment_multi_in \
                "$PLAYER_ANSWER" "$INSTRUCTION_SET"
            ;;
        *)
            debug_msg "Invalid answer type ${RED}$ANSWER_TYPE${RESET}"\
                "for segment."
            return 1
            ;;
    esac
    EXIT_CODE=$?
    debug_msg "Successfully computed puzzle segment instruction set."
    return $EXIT_CODE
}

function compute_puzzle_segment_multi_mode_ok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    OK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    increment_success_count
    mark_current_level_success
    if [ ! -z "$OK_MESSAGE" ]; then
        echo; echo "$OK_MESSAGE
        "; read
    fi
    return ${PM_BEHAVIOURS_OK[$BEHAVIOUR_OK]}
}

function compute_puzzle_segment_multi_mode_nok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    NOK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    NOK_LIMIT=`fetch_segment_instruction_nok_limit "$INSTRUCTION_SET"`
    mark_current_level_failure
    if [ ! -z "$NOK_MESSAGE" ]; then
        echo; echo "$NOK_MESSAGE
        "; read
    fi
    if [ $PM_FAILURE_COUNT -ge $NOK_LIMIT ]; then
        debug_msg "Playthrough interrupted by exceeding"\
            "NOK limit (${RED}$NOK_LIMIT${RESET})."
        return ${PM_BEHAVIOURS_NOK['game-over']}
    fi
    return ${PM_BEHAVIOURS_NOK[$BEHAVIOUR_NOK]}
}

function compute_puzzle_segment_single_in_ok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    OK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    increment_success_count
    mark_current_level_success
    if [ ! -z "$OK_MESSAGE" ]; then
        echo; echo "$OK_MESSAGE
        "; read
    fi
    return ${PM_BEHAVIOURS_OK[$BEHAVIOUR_OK]}
}

function compute_puzzle_segment_single_in_nok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    NOK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    NOK_LIMIT=`fetch_segment_instruction_nok_limit "$INSTRUCTION_SET"`
    mark_current_level_failure
    if [ ! -z "$NOK_MESSAGE" ]; then
        echo; echo "$NOK_MESSAGE
        "; read
    fi
    if [ $PM_FAILURE_COUNT -ge $NOK_LIMIT ]; then
        debug_msg "Playthrough interrupted by exceeding"\
            "NOK limit (${RED}$NOK_LIMIT${RESET})."
        return ${PM_BEHAVIOURS_NOK['game-over']}
    fi
    return ${PM_BEHAVIOURS_NOK[$BEHAVIOUR_NOK]}
}

function compute_puzzle_segment_multi_in_ok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    OK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    increment_success_count
    mark_current_level_success
    if [ ! -z "$OK_MESSAGE" ]; then
        echo; echo "$OK_MESSAGE
        "; read
    fi
    return ${PM_BEHAVIOURS_OK[$BEHAVIOUR_OK]}
}

function compute_puzzle_segment_multi_in_nok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    NOK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    NOK_LIMIT=`fetch_segment_instruction_nok_limit "$INSTRUCTION_SET"`
    mark_current_level_failure
    if [ ! -z "$NOK_MESSAGE" ]; then
        echo; echo "$NOK_MESSAGE
        "; read
    fi
    if [ $PM_FAILURE_COUNT -ge $NOK_LIMIT ]; then
        debug_msg "Playthrough interrupted by exceeding"\
            "NOK limit (${RED}$NOK_LIMIT${RESET})."
        return ${PM_BEHAVIOURS_NOK['game-over']}
    fi
    return ${PM_BEHAVIOURS_NOK[$BEHAVIOUR_NOK]}
}

function compute_puzzle_segment_multi_mode_ok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    OK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    debug_msg "($PLAYER_ANSWER, $BEHAVIOUR_OK, $OK_MESSAGE)"
    increment_success_count
    mark_current_level_success
    if [ ! -z "$OK_MESSAGE" ]; then
        echo; echo "$OK_MESSAGE
        "; read
    fi
    return ${PM_BEHAVIOURS_OK[$BEHAVIOUR_OK]}
}

function compute_puzzle_segment_multi_mode_nok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_NOK=`fetch_segment_instruction_behaviour_nok "$INSTRUCTION_SET"`
    NOK_MESSAGE=`fetch_segment_instruction_behaviour_nok_message "$INSTRUCTION_SET"`
    NOK_LIMIT=`fetch_segment_instruction_nok_limit "$INSTRUCTION_SET"`
    debug_msg "($PLAYER_ANSWER, $BEHAVIOUR_NOK, $NOK_MESSAGE, $NOK_LIMIT)"
    mark_current_level_failure
    if [ ! -z "$NOK_MESSAGE" ]; then
        echo; echo "$NOK_MESSAGE
        "; read
    fi
    if [ $PM_FAILURE_COUNT -ge $NOK_LIMIT ]; then
        debug_msg "Playthrough interrupted by exceeding"\
            "NOK limit (${RED}$NOK_LIMIT${RESET})."
        return ${PM_BEHAVIOURS_NOK['game-over']}
    fi
    return ${PM_BEHAVIOURS_NOK[$BEHAVIOUR_NOK]}
}

function compute_puzzle_segment_single_mode_ok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_OK=`fetch_segment_instruction_behaviour_ok "$INSTRUCTION_SET"`
    OK_MESSAGE=`fetch_segment_instruction_behaviour_ok_message "$INSTRUCTION_SET"`
    debug_msg "($PLAYER_ANSWER, $BEHAVIOUR_OK, $OK_MESSAGE)"
    increment_success_count
    mark_current_level_success
    if [ ! -z "$OK_MESSAGE" ]; then
        echo; echo "$OK_MESSAGE
        "; read
    fi
    return ${PM_BEHAVIOURS_OK[$BEHAVIOUR_OK]}
}

function compute_puzzle_segment_single_mode_nok () {
    local PLAYER_ANSWER="$1"
    local INSTRUCTION_SET="$2"
    BEHAVIOUR_NOK=`fetch_segment_instruction_behaviour_nok "$INSTRUCTION_SET"`
    NOK_MESSAGE=`fetch_segment_instruction_behaviour_nok_message "$INSTRUCTION_SET"`
    NOK_LIMIT=`fetch_segment_instruction_nok_limit "$INSTRUCTION_SET"`
    debug_msg "($PLAYER_ANSWER, $BEHAVIOUR_NOK, $NOK_MESSAGE, $NOK_LIMIT)"
    mark_current_level_failure
    if [ ! -z "$NOK_MESSAGE" ]; then
        echo; echo "$NOK_MESSAGE
        "; read
    fi
    if [ $PM_FAILURE_COUNT -ge $NOK_LIMIT ]; then
        debug_msg "Playthrough interrupted by exceeding"\
            "NOK limit (${RED}$NOK_LIMIT${RESET})."
        return ${PM_BEHAVIOURS_NOK['game-over']}
    fi
    return ${PM_BEHAVIOURS_NOK[$BEHAVIOUR_NOK]}
}





