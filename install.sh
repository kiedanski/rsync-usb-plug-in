echo "Installing the project"
set -a
source variables
envsubst < variables > .variables

set -a
source .variables

UDEV_FILE="/etc/udev/rules.d/10-${PROJECT_NAME}.rules"
envsubst < template.rules | sudo tee "$UDEV_FILE" > /dev/null

SCRIPT_FILE="/usr/local/bin/${PROJECT_NAME}.sh"
envsubst '$LOCAL_DIR $ABSOLUTE_REMOTE_DIR $MOUNT_FILE $NODE_FILE $PIPE_FILE $LOG_FILE $USER' < sync_template.sh | sudo tee "$SCRIPT_FILE" > /dev/null
sudo chmod +x "$SCRIPT_FILE"


BASH_PATH=$(which bash)
[[ "`tail -n1 /etc/rc.local`" == "exit 0" ]] && sudo sed -i -e "\$i "${BASH_PATH}" "${SCRIPT_FILE}" \&" /etc/rc.local

echo "Creating uninstall file"
echo "sudo rm $UDEV_FILE" > uninstall.sh
echo "sudo rm $SCRIPT_FILE" >> uninstall.sh
echo "sudo sed -i -e \"/$PROJECT_NAME/d\" /etc/rc.local" >> uninstall.sh
chmod +x uninstall.sh
