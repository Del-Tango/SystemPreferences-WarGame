#!/bin/bash
#
# Regards, the Alveare Solutions society
#
# [L1C2]: Validator

USER_HOME="/home/Ghost-1"
DIR_PATH="${USER_HOME}/.experiment"
TARGET_DIR="${DIR_PATH}/Mom"
TARGET_FL="${DIR_PATH}/Dad"
FILES_FOUND=0
DIRECTORIES_FOUND=0

for fl_path in `ls "$DIR_PATH"`; do
    if [ -f "$fl_path" ]; then
        FILES_FOUND=$((FILE_FOUND + 1))
    elif [ -d "$fl_path" ]; then
        DIRECTORIES_FOUND=$((DIRECTORIES_FOUND + 1))
    fi
done

if [ $FILES_FOUND -eq 0 ] \
        || [ $DIRECTORIES_FOUND -eq 0 ] \
        || [ -f "$TARGET_FL" ] \
        || [ -d "$TARGET_DIR" ]; then
    echo "[ NOK ]: Chapter (1.2) validation failure! ($FAILURES)"
    exit 1
fi

echo "[ OK ]: Chapter (1.2) complete!"
exit 0

