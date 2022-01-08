#!/usr/bin/env bash

[[ ! -d "$MOUNT_FILE" ]] && sudo mkdir "$MOUNT_FILE" && sudo chown -R "$USER:$USER" "$MOUNT_FILE" 2>"$LOG_FILE"


doSynchronization()
{
  sudo mount "$NODE_FILE" "$MOUNT_FILE" >> "$LOG_FILE" 2>&1
  rsync -rtDvz --ignore-existing $LOCAL_DIR $ABSOLUTE_REMOTE_DIR >> "$LOG_FILE" 2>&1
  sudo umount "$MOUNT_FILE"
}

echo "Starting Kindle Updater" >> "$LOG_FILE"

trap "rm -f $PIPE_FILE" EXIT

#If the pipe doesn't exist, create it
if [[ ! -p $PIPE_FILE ]]; then
    mkfifo $PIPE_FILE
fi

#If the disk is already plugged on startup, do a syn
if [[ -e "$NODE_FILE" ]]
then
    doSynchronization
fi

#Make the permanent loop to watch the usb connection
while true
do
    if read line <$PIPE_FILE; then
        #Test the message read from the fifo
        if [[ "$line" == "connected" ]]
        then
            #The usb has been plugged, wait for disk to be mounted by KDE
            while [[ ! -e "$NODE_FILE" ]]
            do
                sleep 1
            done
            doSynchronization
        else
            echo "Unhandled message from fifo : [$line]"
        fi
    fi
done
echo "Reader exiting"
