#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# POST INSTALL

function post_install () {
    local FAILURES=0
    echo "[ INFO ]: Ensuring user file ownership..."
    ensure_user_file_ownership
    local FAILURES=$((FAILURES + $?))
    echo "[ INFO ]: Exporting config file..."
    cp "${SETUP_DEFAULT['conf-file']}" \
        "${SETUP_DEFAULT['etc-dir']}/${SETUP_DEFAULT['game-conf']}" &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Could not export game config file!"
    else
        echo "[ OK ]: File in position!"\
            "(${SETUP_DEFAULT['etc-dir']}/${SETUP_DEFAULT['game-conf']})"
    fi
    echo "[ INFO ]: Cleaning up..."
    rm -rf ${SETUP_DEFAULT['installer-root']} &> /dev/null
    if [ $? -ne 0 ]; then
        local FAILURES=$((FAILURES + 1))
        echo "[ NOK ]: Cleanup failed!"
    else
        echo "[ OK ]: Squeaky clean!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: Failures detected upon cleanup! ($FAILURES)"
    else
        echo "[ DONE ]: Post install sequence complete!"
    fi
    return $FAILURES
}

# ENSURANCE

function ensure_user_file_ownership () {
    local FAILURES=0
    for user in ${LEVEL_USERS[@]}; do
        local USER_HOME="${SETUP_DEFAULT['home-dir']}/${user}"
        chown -R "$user" "$USER_HOME" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not ensure file ownership for level user!"\
                "(${user})"
        fi
        chgrp -R "$user" "$USER_HOME" &> /dev/null
        if [ $? -ne 0 ]; then
            local FAILURES=$((FAILURES + 1))
            echo "[ NOK ]: Could not ensure file group ownership for level user!"\
                "(${user})"
        fi
    done
    local SUCCESS=`echo "${#LEVEL_USERS[@]} - $FAILURES" | bc`
    if [ $SUCCESS -eq 0 ]; then
        echo "[ NOK ]: Could not ensure user file ownership! ($FAILURES) failures"
    else
        echo "[ OK ]: (${SUCCESS}/${#LEVEL_USERS[@]}) users with file ownership ensured!"
    fi
    if [ $FAILURES -ne 0 ]; then
        echo "[ WARNING ]: File ownership setup failures detected! ($FAILURES)"
    fi
    return $FAILURES
}

