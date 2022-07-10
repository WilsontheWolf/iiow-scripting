#!/bin/bash
echo "[hyjack] Running at $(date +'%D %T')." >> /tmp/hyjack.log
# if args include "--hyjack" then run steam with the args without "--hyjack"
if [[ "$@" == *"--hyjack"* ]]; then
    echo "[hyjack] Hyjacking..." >> /tmp/hyjack.log
    declare -a STEAM_CMD;
    i=0;
    for a in "$@"; do
        if [[ "$a" == "--hyjack"* ]]; then
            export STEAM_RUN=$(echo "$a" | sed -e 's/.*--hyjack //');
            STEAM_CMD[$i]=$(echo "$a" | sed -e 's/.*--hyjack //');
            i=$((i+1));
            continue;
        elif [[ "$a" == *".exe" ]]; then
            continue;
        else
            STEAM_CMD[$i]="$a";
            i=$((i+1));
        fi
    done
    echo "[hyjack] Running: $STEAM_RUN" >> /tmp/hyjack.log
    echo "[hyjack] Output:" >> /tmp/hyjack.log
    echo "\$ ${STEAM_CMD[@]}" >> /tmp/hyjack.log
    "${STEAM_CMD[@]}" >> /tmp/hyjack.log 2>&1
    
else
    echo "[hyjack] Not hyjacking." >> /tmp/hyjack.log
    echo "[hyjack] Output:" >> /tmp/hyjack.log
    echo "\$ $@" >> /tmp/hyjack.log
    "$@" >> /tmp/hyjack.log
fi

echo "[hyjack] Finished." >> /tmp/hyjack.log