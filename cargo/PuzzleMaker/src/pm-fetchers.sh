#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FETCHERS

function fetch_segment_instruction_expected () {
    local INSTRUCTION_SET="$1"
    EXPECTED_VALUE=`echo "$INSTRUCTION_SET" | grep '# EXPECTED: ' | cut -d ':' -f2- | sed 's/^ //'`
    if [ -z "$EXPECTED_VALUE" ]; then
        return 1
    fi
    echo "$EXPECTED_VALUE"
    return 0
}

function fetch_segment_instruction_answer_type () {
    local INSTRUCTION_SET="$1"
    ANSWER_TYPE_VALUE=`echo "$INSTRUCTION_SET" | grep '# ANSWER_TYPE: ' | cut -d ':' -f2- | sed 's/^ //'`
    debug_msg "ANSWER_TYPE instruction value ($ANSWER_TYPE_VALUE)"
    if [ -z "$ANSWER_TYPE_VALUE" ]; then
        return 1
    fi
    echo "$ANSWER_TYPE_VALUE"
    return 0
}

function fetch_segment_instruction_behaviour_ok () {
    local INSTRUCTION_SET="$1"
    BEHAVIOUR_OK=`echo "$INSTRUCTION_SET" | grep '# BEHAVIOUR_OK: ' | awk '{print $3}'`
    if [ -z "$BEHAVIOUR_OK" ]; then
        return 1
    fi
    echo "$BEHAVIOUR_OK"
    return 0
}

function fetch_segment_instruction_behaviour_ok_message () {
    local INSTRUCTION_SET="$1"
    BEHAVIOUR_OK_MSG=`echo "$INSTRUCTION_SET" | grep '# BEHAVIOUR_OK: ' | cut -d' ' -f4-`
    if [ -z "$BEHAVIOUR_OK_MSG" ]; then
        return 1
    fi
    echo "$BEHAVIOUR_OK_MSG"
    return 0
}

function fetch_segment_instruction_behaviour_nok () {
    local INSTRUCTION_SET="$1"
    BEHAVIOUR_NOK=`echo "$INSTRUCTION_SET" | grep '# BEHAVIOUR_NOK: ' | awk '{print $3}'`
    if [ -z "$BEHAVIOUR_NOK" ]; then
        return 1
    fi
    echo "$BEHAVIOUR_NOK"
    return 0
}

function fetch_segment_instruction_behaviour_nok_message () {
    local INSTRUCTION_SET="$1"
    BEHAVIOUR_NOK_MSG=`echo "$INSTRUCTION_SET" | grep '# BEHAVIOUR_NOK: ' | cut -d' ' -f4-`
    if [ -z "$BEHAVIOUR_NOK_MSG" ]; then
        return 1
    fi
    echo "$BEHAVIOUR_NOK_MSG"
    return 0
}

function fetch_segment_instruction_nok_limit () {
    local INSTRUCTION_SET="$1"
    NOK_LIMIT_VALUE=`echo "$INSTRUCTION_SET" | grep '# NOK_LIMIT: ' | awk '{print $3}'`
    if [ -z "$NOK_LIMIT_VALUE" ]; then
        return 1
    fi
    echo "$NOK_LIMIT_VALUE"
    return 0
}

function fetch_puzzle_segment_instruction_set_regex () {
    echo '^# ([A-Z]{3,13}:*|[A-Z]{3,13}_[A-Z]{2,5}:*)'
    return $?
}

function fetch_puzzle_segment_content_regex () {
    echo '^#'
    return $?
}

function fetch_instruction_set_from_puzzle_segment () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        debug_msg "Segment file ${RED}$FILE_PATH${RESET} not found."
        return 1
    fi
    REGEX_PATTERN=`fetch_puzzle_segment_instruction_set_regex`
    cat "$FILE_PATH" | egrep -e "$REGEX_PATTERN"
    return $?
}

function fetch_content_from_puzzle_segment () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        debug_msg "Segment file ${RED}$FILE_PATH${RESET} not found."
        return 1
    fi
    REGEX_PATTERN=`fetch_puzzle_segment_content_regex`
    cat "$FILE_PATH" | egrep -v "$REGEX_PATTERN"
    return $?
}

function fetch_start_puzzle_server_command () {
    local SESSION_HANDLER="$1"
    echo "ncat -klp ${MD_DEFAULT['puzzle-port']} -e $SESSION_HANDLER"
    return $?
}

function fetch_valid_puzzle_playthrough_orders () {
    echo "sorted scrambled"
    return $?
}

function fetch_all_available_puzzle_banners () {
    local PUZZLE_NAME="$1"
    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME"
    check_directory_exists "$FULL_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$FULL_PATH${RESET} not found."
        return 1
    fi
    fetch_all_directory_content "$FULL_PATH" | egrep '^game-*'
    return $?
}

function fetch_all_available_puzzles () {
    check_directory_exists "${MD_DEFAULT['puzzle-dir']}"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}${MD_DEFAULT['puzzle-dir']}${RESET} not found."
        return 1
    fi
    case "${MD_DEFAULT['puzzle-order']}" in
        'sorted')
            PUZZLES=(
                `fetch_all_directory_content "${MD_DEFAULT['puzzle-dir']}"`
            )
            sort_alphanumerically ${PUZZLES[@]}
            ;;
        'scrambled')
            fetch_all_directory_content "${MD_DEFAULT['puzzle-dir']}"
            ;;
        *)
            debug_msg "No valid puzzle playthrough order specified."\
                "Defaulting to sorted."
            PUZZLES=(
                `fetch_all_directory_content "${MD_DEFAULT['puzzle-dir']}"`
            )
            sort_alphanumerically ${PUZZLES[@]}
            ;;
    esac
    return $?
}

function fetch_all_directory_content () {
    local DIRECTORY_PATH="$1"
    check_directory_exists "$DIRECTORY_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$DIRECTORY_PATH${RESET} not found."
        return 1
    fi
    ls -1 "$DIRECTORY_PATH"
    return $?
}

function fetch_all_puzzle_chapters () {
    local PUZZLE_NAME="$1"
    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME"
    check_directory_exists "$FULL_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$FULL_PATH${RESET} not found."
        return 1
    fi
    case "${MD_DEFAULT['puzzle-order']}" in
        'sorted')
            CHAPTERS=(
                `fetch_all_directory_content "$FULL_PATH" | egrep -v '^game-*'`
            )
            sort_alphanumerically ${CHAPTERS[@]}
            ;;
        'scrambled')
            fetch_all_directory_content "$FULL_PATH" | egrep -v '^game-*'
            ;;
        *)
            debug_msg "No valid puzzle playthrough order specified."\
                "Defaulting to sorted."
            CHAPTERS=(
                `fetch_all_directory_content "$FULL_PATH" | egrep -v '^game-*'`
            )
            sort_alphanumerically ${CHAPTERS[@]}
            ;;
    esac
    return $?
}

function fetch_all_puzzle_chapter_sections () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME/$PUZZLE_CHAPTER"
    check_directory_exists "$FULL_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$FULL_PATH${RESET} not found."
        return 1
    fi
    case "${MD_DEFAULT['puzzle-order']}" in
        'sorted')
            SECTIONS=(
                `fetch_all_directory_content "$FULL_PATH"`
            )
            sort_alphanumerically ${SECTIONS[@]}
            ;;
        'scrambled')
            fetch_all_directory_content "$FULL_PATH"
            ;;
        *)
            debug_msg "No valid puzzle playthrough order specified."\
                "Defaulting to sorted."
            SECTIONS=(
                `fetch_all_directory_content "$FULL_PATH"`
            )
            sort_alphanumerically ${SECTIONS[@]}
            ;;
    esac
    return $?
}

function fetch_all_puzzle_chapter_section_segments () {
    local PUZZLE_NAME="$1"
    local PUZZLE_CHAPTER="$2"
    local PUZZLE_SECTION="$3"
    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_NAME/$PUZZLE_CHAPTER/$PUZZLE_SECTION"
    check_directory_exists "$FULL_PATH"
    if [ $? -ne 0 ]; then
        error_msg "Directory ${RED}$FULL_PATH${RESET} not found."
        return 1
    fi
    case "${MD_DEFAULT['puzzle-order']}" in
        'sorted')
            SEGMENTS=(
                `fetch_all_directory_content "$FULL_PATH" | grep '.seg'`
            )
            sort_alphanumerically ${SEGMENTS[@]}
            ;;
        'scrambled')
            fetch_all_directory_content "$FULL_PATH" | grep '.seg'
            ;;
        *)
            debug_msg "No valid puzzle playthrough order specified."\
                "Defaulting to sorted."
            SEGMENTS=(
                `fetch_all_directory_content "$FULL_PATH" | grep '.seg'`
            )
            sort_alphanumerically ${SEGMENTS[@]}
            ;;
    esac
    return $?
}

function fetch_external_ipv4_address () {
    check_internet_access
    if [ $? -ne 0 ]; then
        warning_msg "No internet access detected."
        return 1
    fi
    curl whatismyip.akamai.com 2> /dev/null
    return $?
}

function fetch_local_ipv4_address () {
    hostname -I | cut -d' ' -f 1
    return $?
}



