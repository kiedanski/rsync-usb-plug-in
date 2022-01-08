set -a
source variables
envsubst < variables > .variables

set -a
source .variables

UDEV_FILE="/etc/udev/rules.d/10-${PROJECT_NAME}.rules"
envsubst < template.rules | sudo tee "$UDEV_FILE" 

envsubst '$LOCAL_DIR $ABSOLUTE_REMOTE_DIR $MOUNT_FILE $NODE_FILE $PIPE_FILE $LOG_FILE $USER' < sync_template.sh > sync.sh
