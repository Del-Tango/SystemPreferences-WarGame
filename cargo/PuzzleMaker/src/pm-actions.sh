#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_start_puzzle_server () {
    echo; perform_puzzle_server_verifications
    if [ $? -ne 0 ]; then
        warning_msg "${RED}$SCRIPT_NAME${RESET} preliminary"\
            "verifications failed."
        return 1
    fi
    COMMAND=`fetch_start_puzzle_server_command "$PM_DIRECTORY/puzzle-maker"`
    debug_msg "Executing command (${MAGENTA}$COMMAND${RESET})."
    info_msg "Running ${BLUE}$SCRIPT_NAME${RESET} game server"\
        "at (${WHITE}`fetch_local_ipv4_address`:${MD_DEFAULT['puzzle-port']}${RESET})."
    info_msg "You migh want to put this process in the background using"\
        "${MAGENTA}Ctrl-z${RESET} followed by the ${MAGENTA}bg${RESET} command."
    $COMMAND
    return $?
}

function action_set_puzzle_game () {
    VALID_PUZZLES=( `fetch_all_available_puzzles` )
    echo; while :
    do
        info_msg "Select puzzle to load or ${MAGENTA}Back${RESET}.
        "
        PUZZLE_GAME=`fetch_selection_from_user 'Puzzle'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        break
    done

    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE_GAME"
    echo; set_puzzle_game "$FULL_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load puzzle ${RED}$FULL_PATH${RESET}."
    else
        ok_msg "Successfully loaded puzzle ${GREEN}$FULL_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_puzzle_port () {
    echo; while :
    do
        info_msg "Type puzzle server port or ${MAGENTA}.back${RESET}.
        "
        PORT_NUMBER=`fetch_data_from_user 'PortNumber'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_value_is_number $PORT_NUMBER
        if [ $? -ne 0 ]; then
            echo; warning_msg "Illegal data set."\
                "Port number must be an integer,"\
                "not ${RED}$PORT_NUMBER${RESET}."
            continue
        fi
        break
    done
    echo; set_puzzle_port_number "$PORT_NUMBER"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set puzzle port number"\
            "to ${RED}$PORT_NUMBER${RESET}."
    else
        ok_msg "Successfully set puzzle port number"\
            "to ${GREEN}$PORT_NUMBER${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_puzzle_order () {
    VALID_ORDERS=( `fetch_valid_puzzle_playthrough_orders` )
    echo; while :
    do
        info_msg "Select puzzle order or ${MAGENTA}Back${RESET}.
        "
        ORDER=`fetch_selection_from_user 'PlayOrder' ${VALID_ORDERS[@]}`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        break
    done
    echo; set_puzzle_playthrough_order "$ORDER"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set puzzle playthrough"\
            "order to ${RED}$ORDER${RESET}."
    else
        ok_msg "Successfully set puzzle playthrough"\
            "order to ${GREEN}$ORDER${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_puzzle_directory () {
    echo; while :
    do
        info_msg "Type absolute directory path or ${MAGENTA}.back${RESET}.
        "
        DIR_PATH=`fetch_data_from_user 'DirPath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "Directory ${RED}$DIR_PATH${RESET} does not exists."
            echo; continue
        fi; break
    done
    echo; set_active_puzzle_directory "$DIR_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$DIR_PATH${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} puzzle box directory."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET}"\
            "puzzle box directory ${GREEN}$DIR_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_edit_puzzle_banner () {

    check_directory_exists "${MD_DEFAULT['puzzle-path']}"
    if [ $? -ne 0 ]; then
        echo; warning_msg "No default puzzle path set."
        AVAILABLE_PUZZLES=( `fetch_all_available_puzzles` )
        while :
        do
            info_msg "Select puzzle or ${MAGENTA}Back${RESET}.
            "
            PUZZLE=`fetch_selection_from_user 'Puzzle' ${AVAILABLE_PUZZLES[@]}`
            if [ $? -ne 0 ]; then
                echo; info_msg "Aborting action."
                return 0
            fi
            break
        done
    else
        PUZZLE=`basename ${MD_DEFAULT['puzzle-path']}`
    fi

    AVAILABLE_BANNERS=( `fetch_all_available_puzzle_banners "$PUZZLE"` )
    echo; while :
    do
        info_msg "Select ${YELLOW}$PUZZLE${RESET}"\
            "banner or ${MAGENTA}Back${RESET}.
            "
        BANNER=`fetch_selection_from_user 'Banner' ${AVAILABLE_BANNERS[@]}`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        break
    done

    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE/$BANNER"
    edit_file "$FULL_PATH"; echo
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not edit puzzle banner ${RED}$FULL_PATH${RESET}."
    else
        ok_msg "Successfully edited puzzle banner ${GREEN}$FULL_PATH${RESET}."
    fi

    return $EXIT_CODE
}

function action_edit_puzzle () {

    check_directory_exists "${MD_DEFAULT['puzzle-path']}"
    if [ $? -ne 0 ]; then
        echo; warning_msg "No default puzzle path set."
        AVAILABLE_PUZZLES=( `fetch_all_available_puzzles` )
        while :
        do
            info_msg "Select puzzle or ${MAGENTA}Back${RESET}.
            "
            PUZZLE=`fetch_selection_from_user 'Puzzle' ${AVAILABLE_PUZZLES[@]}`
            if [ $? -ne 0 ]; then
                echo; info_msg "Aborting action."
                return 0
            fi
            break
        done
    else
        PUZZLE=`basename ${MD_DEFAULT['puzzle-path']}`
    fi

    AVAILABLE_CHAPTERS=( `fetch_all_puzzle_chapters "$PUZZLE"` )
    echo; while :
    do
        info_msg "Select ${YELLOW}$PUZZLE${RESET}"\
            "chapter or ${MAGENTA}Back${RESET}.
            "
        CHAPTER=`fetch_selection_from_user 'Chapter' ${AVAILABLE_CHAPTERS[@]}`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        break
    done

    AVAILABLE_SECTIONS=(
        `fetch_all_puzzle_chapter_sections "$PUZZLE" "$CHAPTER"`
    )
    echo; while :
    do
        info_msg "Select ${YELLOW}$PUZZLE/$CHAPTER${RESET}"\
            "section or ${MAGENTA}Back${RESET}.
            "
        SECTION=`fetch_selection_from_user 'Section' ${AVAILABLE_SECTIONS[@]}`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        break
    done

    AVAILABLE_SEGMENTS=(
        `fetch_all_puzzle_chapter_section_segments \
            "$PUZZLE" "$CHAPTER" "$SECTION"`
    )
    echo; while :
    do
        info_msg "Select ${YELLOW}$PUZZLE/$CHAPTER/$SECTION${RESET}"\
            "segment or ${MAGENTA}Back${RESET}.
            "
        SEGMENT=`fetch_selection_from_user 'Segment' ${AVAILABLE_SEGMENTS[@]}`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        break
    done

    local FULL_PATH="${MD_DEFAULT['puzzle-dir']}/$PUZZLE/$CHAPTER/$SECTION/$SEGMENT"
    edit_file "$FULL_PATH"; echo
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not edit puzzle segment ${RED}$FULL_PATH${RESET}."
    else
        ok_msg "Successfully edited puzzle segment ${GREEN}$FULL_PATH${RESET}."
    fi

    return $EXIT_CODE
}

function action_install_dependencies () {
    echo
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    apt_install_dependencies
    return $?
}

function action_set_temporary_file () {
    echo; info_msg "Type absolute file path or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File ${RED}$FILE_PATH${RESET} does not exists."
            echo; continue
        fi; break
    done
    set_temporary_file "$FILE_PATH"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_PATH${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} temporary file."
    else
        ok_msg "Successfully set temporary file ${GREEN}$FILE_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_log_file () {
    echo; info_msg "Type absolute file path or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File ${RED}$FILE_PATH${RESET} does not exists."
            echo; continue
        fi; break
    done
    echo; set_log_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_PATH${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} log file."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} log file"\
            "${GREEN}$FILE_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_log_lines () {
    echo; info_msg "Type log line number to display or ${MAGENTA}.back${RESET}."
    while :
    do
        LOG_LINES=`fetch_data_from_user 'LogLines'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_value_is_number $LOG_LINES
        if [ $? -ne 0 ]; then
            warning_msg "LogViewer number of lines requiered,"\
                "not ${RED}$LOG_LINES${RESET}."
            echo; continue
        fi; break
    done
    echo; set_log_lines $LOG_LINES
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${RED}log lines${RESET} to (${RED}$LOG_LINES${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}log lines${RESET} to (${GREEN}$LOG_LINES${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_file_editor () {
    echo; info_msg "Type file editor name or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_EDITOR=`fetch_data_from_user 'Editor'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_util_installed "$FILE_EDITOR"
        if [ $? -ne 0 ]; then
            warning_msg "File editor ${RED}$FILE_EDITOR${RESET} is not installed."
            echo; continue
        fi; break
    done
    set_file_editor "$FILE_EDITOR"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_EDITOR${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} default file editor."
    else
        ok_msg "Successfully set default file editor"\
            "${GREEN}$FILE_EDITOR${RESET}."
    fi
    return $EXIT_CODE
}

