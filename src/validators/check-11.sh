#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L1C1]: Validator

USER_HOME="/home/Ghost-1"
DIR_PATH="${USER_HOME}/.RnM"
TARGET_DIR="${DIR_PATH}/PretentiousMOFO"
FILE_NO=125
DETECTED_FILES=()

for fl_path in `find "$DIR_PATH" -executable -type f`; do
    CONTENT=`cat "$fl_path"`
    FILTERED=`echo "$CONTENT" | grep '#!/bin/bash'`
    if [ ! -z "$FILTERED" ]; then
        echo "$fl_path"
        DETECTED_FILES=( ${DETECTED_FILES[@]} "$fl_path" )
    fi
done

FAILURES=0
for fl_path in ${DETECTED_FILES[@]}; do
    FL_DIR=`dirname "${fl_path}"`
    if [[ "$FL_DIR" != "$TARGET_DIR" ]]; then
        FAILURES=$((FAILURES + 1))
    fi
done

if [ `ls -1 ${TARGET_DIR} | wc -l` -ne $FILE_NO ]; then
    FAILURES=$((FAILURES + 1))
fi

if [ $FAILURES -ne 0 ]; then
    echo "[ NOK ]: Chapter (1.1) validation failure! ($FAILURES)"
else
    echo "[ OK ]: Chapter (1.1) complete!"
fi
exit $FAILURES

