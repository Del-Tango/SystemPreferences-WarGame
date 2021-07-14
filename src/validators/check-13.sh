#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L1C3]: Validator

USER_HOME="/home/Ghost-1"
DIR_PATH="${USER_HOME}/.experiment"
EVIDENCE_DIR="${DIR_PATH}/.evidence"
RUG_DIR="${DIR_PATH}/.rug"
FILE_NO=26
EVIDENCE_FOUND=( `find ${DIR_PATH} -name 'evidence'*` )
FAILURES=0

for fl_path in "${EVIDENCE_FOUND[@]}"; do
    FL_DIR=`dirname "$fl_path"`
    if [[ "$FL_DIR" == "$RUG_DIR" ]] \
            || [[ "$FL_DIR" == "$EVIDENCE_DIR" ]]; then
        continue
    fi
    FAILURES=$((FAILURES + 1))
done

if [ ${#EVIDENCE_FOUND[@]} -ne $FILE_NO ]; then
    FAILURES=$((FAILURES + 1))
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (1.3) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (1.3) complete!"
exit 0

