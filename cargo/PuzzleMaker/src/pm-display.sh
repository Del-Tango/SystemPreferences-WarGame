#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_puzzle_segment_content () {
    local SEGMENT_CONTENT="$@"
    echo $SEGMENT_CONTENT
    return $?
}

function display_puzzle_maker_banner () {
    figlet -f lean -w 1000 "$SCRIPT_NAME" > "${MD_DEFAULT['tmp-file']}"
    clear; echo -n "${BLUE}`cat ${MD_DEFAULT['tmp-file']}`${RESET}"
    echo -n > ${MD_DEFAULT['tmp-file']}
    return 0
}

function display_internet_connection () {
    check_internet_access
    if [ $? -ne 0 ]; then
        local DISPLAY_FLAG="${RED}OFF${RESET}"
    else
        local DISPLAY_FLAG="${GREEN}ON${RESET}"
    fi
    echo "[ ${CYAN}Internet Connection${RESET}    ]: $DISPLAY_FLAG"
    return $?
}

function display_internal_ip_address () {
    INTERNAL_IP_ADDRESS=`fetch_local_ipv4_address`
    if [ $? -ne 0 ]; then
        return 1
    fi
    echo "[ ${CYAN}Internal IPv4${RESET}          ]: ${WHITE}$INTERNAL_IP_ADDRESS${RESET}"
    return $?
}

function display_external_ip_address () {
    EXTERNAL_IP_ADDRESS=`fetch_external_ipv4_address`
    if [ $? -ne 0 ]; then
        return 1
    fi
    echo "[ ${CYAN}External IPv4${RESET}          ]: ${WHITE}$EXTERNAL_IP_ADDRESS${RESET}"
    return $?
}

function display_additional_settings () {
    display_internet_connection
    display_internal_ip_address
    display_external_ip_address
    cat ${MD_DEFAULT['tmp-file']}
    return $?
}

function display_puzzle_maker_settings () {
    echo "[ ${CYAN}Conf File${RESET}              ]: ${YELLOW}${MD_DEFAULT['conf-file']}${RESET}
[ ${CYAN}Log File${RESET}               ]: ${YELLOW}${MD_DEFAULT['log-file']}${RESET}
[ ${CYAN}Temporary File${RESET}         ]: ${YELLOW}${MD_DEFAULT['tmp-file']}${RESET}
[ ${CYAN}File Editor${RESET}            ]: ${MAGENTA}${MD_DEFAULT['file-editor']}${RESET}
[ ${CYAN}Log Lines${RESET}              ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}Puzzle Directory${RESET}       ]: ${BLUE}${MD_DEFAULT['puzzle-dir']}${RESET}
[ ${CYAN}Puzzle Loaded${RESET}          ]: ${YELLOW}${MD_DEFAULT['puzzle-path']}${RESET}
[ ${CYAN}Puzzle Order${RESET}           ]: ${MAGENTA}${MD_DEFAULT['puzzle-order']}${RESET}
[ ${CYAN}Puzzle Port${RESET}            ]: ${WHITE}${MD_DEFAULT['puzzle-port']}${RESET}" | column
    display_additional_settings; echo
    return 0
}

