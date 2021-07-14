#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function setup_puzzle_maker_apt_dependencies () {
    if [ ${#PM_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${PM_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

function setup_puzzle_maker_dependencies () {

    setup_puzzle_maker_apt_dependencies

    return 0
}

function setup_settings_menu_controller () {

    setup_settings_menu_option_set_temporary_file
    setup_settings_menu_option_set_log_file
    setup_settings_menu_option_set_log_lines
    setup_settings_menu_option_set_file_editor
    setup_settings_menu_option_set_puzzle_game
    setup_settings_menu_option_set_puzzle_port
    setup_settings_menu_option_set_puzzle_order
    setup_settings_menu_option_set_puzzle_directory
    setup_settings_menu_option_edit_puzzle
    setup_settings_menu_option_edit_puzzle_banner
    setup_settings_menu_option_install_dependencies
    setup_settings_menu_option_back

    done_msg "${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."

    return 0
}

function setup_log_viewer_menu_controller () {

    setup_log_viewer_menu_option_display_tail
    setup_log_viewer_menu_option_display_head
    setup_log_viewer_menu_option_display_more
    setup_log_viewer_menu_option_clear_log_file
    setup_log_viewer_menu_option_back
    done_msg "${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."

    return 0
}

function setup_main_menu_controller () {

    setup_main_menu_option_start_puzzle_server
    setup_main_menu_option_log_viewer
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."

    return 0
}

function setup_puzzle_maker_menu_controllers () {

    setup_puzzle_maker_dependencies
    setup_main_menu_controller
    setup_log_viewer_menu_controller
    setup_settings_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."

    return 0
}

# LOG VIEWER MENU SETUP

function setup_log_viewer_menu_option_clear_log_file () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Clear-Log${RESET}"\
        "to function ${MAGENTA}action_clear_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Clear-Log' "action_clear_log_file"

    return $?
}

function setup_log_viewer_menu_option_display_tail () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Tail${RESET}"\
        "to function ${MAGENTA}action_display_log_tail${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Tail' "action_log_view_tail"

    return $?
}

function setup_log_viewer_menu_option_display_head () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Head${RESET}"\
        "to function ${MAGENTA}action_display_log_head${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Head' "action_log_view_head"

    return $?
}

function setup_log_viewer_menu_option_display_more () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-More${RESET}"\
        "to function ${MAGENTA}action_display_log_more${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-More' "action_log_view_more"

    return $?
}

function setup_log_viewer_menu_option_back () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" 'Back' "action_back"

    return $?
}

# MAIN MENU SETUP

function setup_main_menu_option_start_puzzle_server () {

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Start-Puzzle-Server${RESET}"\
        "to function ${MAGENTA}action_start_puzzle_server${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" \
        'Start-Puzzle-Server' "action_start_puzzle_server"

    return $?
}

function setup_main_menu_option_log_viewer () {

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Log-Viewer${RESET}"\
        "to controller ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Log-Viewer' "$LOGVIEWER_CONTROLLER_LABEL"

    return $?
}

function setup_main_menu_option_control_panel () {

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Control-Panel${RESET}"\
        "to controller ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Control-Panel' "$SETTINGS_CONTROLLER_LABEL"

    return $?
}

function setup_main_menu_option_back () {

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" 'Back' "action_back"

    return $?
}

# SETTINGS MENU SETUP

function setup_settings_menu_option_set_puzzle_game () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Game${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_game${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Game" 'action_set_puzzle_game'

    return $?
}

function setup_settings_menu_option_set_puzzle_port () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Port${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_port${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Port" 'action_set_puzzle_port'

    return $?
}

function setup_settings_menu_option_set_puzzle_order () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Order${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_order${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Order" 'action_set_puzzle_order'

    return $?
}

function setup_settings_menu_option_set_puzzle_directory () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Directory${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_directory${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Directory" 'action_set_puzzle_directory'

    return $?
}

function setup_settings_menu_option_edit_puzzle_banner () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Edit-Puzzle-Banner${RESET}"\
        "to function ${MAGENTA}action_edit_puzzle_banner${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Edit-Puzzle-Banner" 'action_edit_puzzle_banner'

    return $?
}

function setup_settings_menu_option_set_puzzle_game () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Game${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_game${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Game" 'action_set_puzzle_game'

    return $?
}

function setup_settings_menu_option_set_puzzle_port () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Port${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_port${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Port" 'action_set_puzzle_port'

    return $?
}

function setup_settings_menu_option_set_puzzle_order () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Order${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_order${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Order" 'action_set_puzzle_order'

    return $?
}

function setup_settings_menu_option_set_puzzle_directory () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Puzzle-Directory${RESET}"\
        "to function ${MAGENTA}action_set_puzzle_directory${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Puzzle-Directory" 'action_set_puzzle_directory'

    return $?
}

function setup_settings_menu_option_edit_puzzle () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Edit-Puzzle${RESET}"\
        "to function ${MAGENTA}action_edit_puzzle${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Edit-Puzzle" 'action_edit_puzzle'

    return $?
}

function setup_settings_menu_option_set_file_editor () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-File-Editor${RESET}"\
        "to function ${MAGENTA}action_set_file_editor${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-File-Editor" 'action_set_file_editor'

    return $?
}

function setup_settings_menu_option_set_temporary_file () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Temporary-File${RESET}"\
        "to function ${MAGENTA}action_set_temporary_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Temporary-File" 'action_set_temporary_file'

    return $?
}

function setup_settings_menu_option_set_log_file () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-File${RESET}"\
        "to function ${MAGENTA}action_set_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-File" 'action_set_log_file'

    return $?
}

function setup_settings_menu_option_set_log_lines () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-Lines${RESET}"\
        "to function ${MAGENTA}action_set_log_lines${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-Lines" 'action_set_log_lines'

    return $?
}

function setup_settings_menu_option_install_dependencies () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Install-Dependencies" 'action_install_dependencies'

    return $?
}

function setup_settings_menu_option_back () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" 'Back' "action_back"

    return $?
}

