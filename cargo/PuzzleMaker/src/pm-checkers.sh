#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CHECKERS

function check_internet_access () {
    ping -c 1 www.github.com 2> /dev/null
    return $?
}

