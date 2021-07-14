#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# PUZZLE MAKER

function load_puzzle_maker_logging_levels () {
    if [ ${#PM_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${PM_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_puzzle_maker_default () {
    if [ ${#PM_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for pm_setting in ${!PM_DEFAULT[@]}; do
        MD_DEFAULT[$pm_setting]=${PM_DEFAULT[$pm_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$pm_setting - ${PM_DEFAULT[$pm_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_puzzle_maker_script_name () {
    if [ -z "$PM_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SRIPT_NAME."
        return 1
    fi
    set_project_name "$PM_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$PM_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$PM_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

function load_puzzle_maker_prompt_string () {
    if [ -z "$PM_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    set_project_prompt "$PM_PS3"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$PM_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$PM_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_puzzle_maker_config () {
    load_puzzle_maker_script_name
    load_puzzle_maker_prompt_string
    load_settings_puzzle_maker_default
    load_puzzle_maker_logging_levels
}

function puzzle_maker_project_setup () {
    lock_and_load
    load_puzzle_maker_config
    create_puzzle_maker_menu_controllers
    setup_puzzle_maker_menu_controllers
}

