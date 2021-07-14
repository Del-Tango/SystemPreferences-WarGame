#!/bin/bash
#
# Regards, the Alveare Solutions society,
#
# CLEANUP

function tear_down () {
    deluser Ghost-1
    deluser Ghost-2
    deluser Ghost-3
    deluser Ghost-4
    deluser Ghost-5
    deluser Ghost-6
    deluser Ghost-7
    deluser Ghost-8
    echo -n > '/home/Ghost/.bashrc'
    rm -rf \
        /opt/* \
        /root/SystemPreferences/ \
        `ls /home | egrep -e '-.'` \
        /home/Ghost-* \
        /opt/PuzzleMaker \
        /home/Ghost/* \
        /home/Ghost/.* \
        /etc/ordinary-every-day-regular-file \
        /bin/.FriendlyEnterpriseDebugger-Backdoor.sh \
        /bin/.FED-Blocker.sh
    return $?
}
