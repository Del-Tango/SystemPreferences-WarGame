#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# HANDLERS

function handle_puzzle_segment () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    local PUZZLE_SEGMENT="$4"
    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME/$PUZZLE_CHAPTER/$PUZZLE_SECTION/$PUZZLE_SEGMENT"
    check_file_exists "$FULL_PATH"
    if [ $? -ne 0 ]; then
        debug_msg "Puzzle segment file ${RED}$FULL_PATH${RESET} does not exist."
        return 1
    fi

    SEGMENT_INSTRUCTIONS=`fetch_instruction_set_from_puzzle_segment "$FULL_PATH"`
    debug_msg "Segment ($PUZZLE_SEGMENT) instructions: $SEGMENT_INSTRUCTIONS"

    SEGMENT_CONTENT=`fetch_content_from_puzzle_segment "$FULL_PATH"`
    debug_msg "Segment ($PUZZLE_SEGMENT) content: $SEGMENT_CONTENT"

    echo; echo "$SEGMENT_CONTENT"
    echo; read -a PLAYER_ANSWER
    local ANSWER_STRING="${PLAYER_ANSWER[@]}"
    debug_msg "Player answer ($ANSWER_STRING)."

    compute_puzzle_segment_instruction_set \
        "$ANSWER_STRING" "$SEGMENT_INSTRUCTIONS"
    BEHAVIOUR_CODE=$?
    process_behaviour_code $BEHAVIOUR_CODE "$PUZZLE_NAME" "$PUZZLE_CHAPTER" \
        "$PUZZLE_SECTION" "$PUZZLE_SEGMENT"
    return $?
}

function handle_puzzle_section () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    PUZZLE_SEGMENTS=(
        `fetch_all_puzzle_chapter_section_segments \
            "$PUZZLE_NAME" "$PUZZLE_CHAPTER" "$PUZZLE_SECTION"`
    )
    FAILURE_COUNT=0
    for segment in ${PUZZLE_SEGMENTS[@]}; do
        clear; handle_puzzle_segment "$PUZZLE_NAME" "$PUZZLE_CHAPTER" \
            "$PUZZLE_SECTION" "$segment"
        EXIT_CODE=$?
        case $EXIT_CODE in
            1|2|3|4|5|6|7|8|9)
                debug_msg "Handling failure for puzzle ${RED}$PUZZLE_NAME${RESET}"\
                    "chapter ${RED}$CHAPTER${RESET} section ${RED}$section${RESET}"\
                    "segment ${RED}$segment${RESET}."
                FAILURE_COUNT=$((FAILURE_COUNT + 1))
                ;;
            102|103)
                return $EXIT_CODE
                ;;
        esac
    done
    debug_msg "Finished puzzle ${GREEN}$PUZZLE_NAME${RESET}"\
        "playthrough of (${WHITE}${#PUZZLE_SEGMENTS[@]}${RESET}) segments."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

function handle_puzzle_chapter () {
    local PUZZLE_NAME="$1"
    local CHAPTER="$2"
    PUZZLE_SECTIONS=(
        `fetch_all_puzzle_chapter_sections "$PUZZLE_NAME" "$CHAPTER"`
    )
    FAILURE_COUNT=0
    for section in ${PUZZLE_SECTIONS[@]}; do
        clear; handle_puzzle_section "$PUZZLE_NAME" "$CHAPTER" "$section"
        EXIT_CODE=$?
        case $EXIT_CODE in
            1|2|3|4|5|6|7|8|9)
                debug_msg "Handling failure for puzzle ${RED}$PUZZLE_NAME${RESET}"\
                    "chapter ${RED}$CHAPTER${RESET} section ${RED}$section${RESET}."
                FAILURE_COUNT=$((FAILURE_COUNT + 1))
                ;;
            102|103)
                return $EXIT_CODE
                ;;
        esac
    done
    debug_msg "Finished puzzle ${GREEN}$PUZZLE_NAME${RESET}"\
        "playthrough of (${WHITE}${#PUZZLE_SECTIONS[@]}${RESET}) sections."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

function handle_puzzle_playthrough () {
    PUZZLE_NAME=`basename ${MD_DEFAULT['puzzle-path']}`
    PUZZLE_CHAPTERS=( `fetch_all_puzzle_chapters "$PUZZLE_NAME"` )
    FAILURE_COUNT=0
    DISPLAYED_BANNER='false'
    for chapter in ${PUZZLE_CHAPTERS[@]}; do
        clear; if [[ "$DISPLAYED_BANNER" == "false" ]]; then
            cat "${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME/game-banner"
            DISPLAY_BANNER='true'
            read
        fi
        handle_puzzle_chapter "$PUZZLE_NAME" "$chapter"
        EXIT_CODE=$?
        case $EXIT_CODE in
            1|2|3|4|5|6|7|8|9)
                debug_msg "Handling failure for puzzle ${RED}$PUZZLE_NAME${RESET}"\
                    "chapter ${RED}$chapter${RESET}."
                FAILURE_COUNT=$((FAILURE_COUNT + 1))
                ;;
            102)
                handle_puzzle_playthrough
                return $?
                ;;
            103)
                break
                ;;
        esac
    done
    debug_msg "Finished puzzle ${GREEN}$PUZZLE_NAME${RESET}"\
        "playthrough of (${WHITE}${#PUZZLE_CHAPTERS[@]}${RESET}) chapters."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    for item in `seq 3`; do echo -n '.' && sleep 1s; done; clear; echo
    cat "${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME/game-over"
    read; return 0
}

