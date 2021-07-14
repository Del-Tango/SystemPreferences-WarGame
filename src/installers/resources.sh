#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# RESOURCES

function check_ssh_service_running () {
    service ssh status &> /dev/null
    return $?
}

function stop_ssh_server () {
    service ssh stop &> /dev/null
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        echo "[ NOK ]: Could not stop SSH server! ($EXIT_CODE)"
    else
        echo "[ OK ]: SSH server offline!"
    fi
    return $EXIT_CODE
}

function ensure_ssh_service_offline () {
    local EXIT_CODE=0
    check_ssh_service_running
    if [ $? -eq 0 ]; then
        stop_ssh_server
        local EXIT_CODE=$?
    fi
    return $EXIT_CODE
}

function check_user_exists () {
    local USER_NAME="$1"
    id "${USER_NAME}" &> /dev/null
    return $?
}

function create_user () {
    local USER_NAME="$1"
    if [ -z "$USER_NAME" ]; then
        echo "[ ERROR ]: No user name provided!"
        return 1
    fi
    local USER_PASS="${USER_PASSWORDS[$USER_NAME]}"
    useradd --create-home --shell /bin/bash \
            --password $(echo ${USER_PASS} | openssl passwd -1 -stdin) \
            ${USER_NAME} #&> /dev/null
    return $?
}
