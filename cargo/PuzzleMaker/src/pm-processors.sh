#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# PROCESSORS

function process_behaviour_game_over () {
    return ${PM_BEHAVIOURS_OK['game-over']}
}

function process_behaviour_continue_indexed () {
    increment_failure_count
    return ${PM_BEHAVIOURS_NOK['continue-indexed']}
}

function process_behaviour_continue_unindexed () {
    return ${PM_BEHAVIOURS_NOK['continue-unindexed']}
}

function process_behaviour_repeat_indexed () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    local PUZZLE_SEGMENT="$4"
    increment_failure_count
    clear; handle_puzzle_segment \
        "$PUZZLE_NAME" "$PUZZLE_CHAPTER" "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
    return $?
}

function process_behaviour_repeat_unindexed () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    local PUZZLE_SEGMENT="$4"
    clear; handle_puzzle_segment \
        "$PUZZLE_NAME" "$PUZZLE_CHAPTER" "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
    return $?
}

function process_behaviour_continue () {
    return ${PM_BEHAVIOURS_OK['continue']}
}

function process_behaviour_repeat () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    local PUZZLE_SEGMENT="$4"
    clear; handle_puzzle_segment \
        "$PUZZLE_NAME" "$PUZZLE_CHAPTER" "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
    return $?
}

function process_behaviour_restart () {
    reset_score
    return ${PM_BEHAVIOURS_OK['restart']}
}

function process_behaviour_code () {
    local BEHAVIOUR_CODE=$1
    local PUZZLE_NAME="$2"
    local PUZZLE_CHAPTER="$3"
    local PUZZLE_SECTION="$4"
    local PUZZLE_SEGMENT="$5"
    case $BEHAVIOUR_CODE in
        100)
            process_behaviour_continue
            ;;
        101)
            process_behaviour_repeat "$PUZZLE_NAME" "$PUZZLE_CHAPTER" \
                "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
            ;;
        102)
            process_behaviour_restart
            ;;
        103)
            process_behaviour_game_over
            ;;
        104)
            process_behaviour_continue_indexed
            ;;
        105)
            process_behaviour_continue_unindexed
            ;;
        106)
            process_behaviour_repeat_indexed "$PUZZLE_NAME" "$PUZZLE_CHAPTER" \
                "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
            ;;
        107)
            process_behaviour_repeat_unindexed "$PUZZLE_NAME" "$PUZZLE_CHAPTER" \
                "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
            ;;
        *)
            return $BEHAVIOUR_CODE
            ;;
    esac
    return $?
}

