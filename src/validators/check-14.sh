#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L1C4]: Validator

USER_HOME="/home/Ghost-1"
DIR_PATH="${USER_HOME}/.experiment"
EVIDENCE_DIR="${DIR_PATH}/.evidence"
RUG_DIR="${DIR_PATH}/.rug"
FILE_NO=13
EVIDENCE_FOUND=( `find ${DIR_PATH} -name 'evidence'*` )
FAILURES=0

if [ ! -d "${DIR_PATH}" ] \
    || [ ! -d "${EVIDENCE_DIR}" ] \
    || [ ! -d "${RUG_DIR}" ]; then
    echo "[ OK ]: Chapter (1.4) complete!"
    exit 0
fi

for fl_path in "${EVIDENCE_FOUND[@]}"; do
    FL_DIR=`dirname "$fl_path"`
    if [[ "$FL_DIR" == "$RUG_DIR" ]]; then
        continue
    fi
    FAILURES=$((FAILURES + 1))
done

if [ ${#EVIDENCE_FOUND[@]} -ne $FILE_NO ]; then
    FAILURES=$((FAILURES + 1))
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (1.4) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (1.4) complete!"
exit 0

