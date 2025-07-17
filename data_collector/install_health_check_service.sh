#!/bin/bash

## Full Path to script
SCRIPT_PATH="$(realpath sysHealthCheck.php)"

if [ ! -f "$SCRIPT_PATH" ]; then
	echo "Error sysHealthCheck.php file not found."
	exit 1
fi

## Define Service and Time Filenames
SERVICE_NAME="syshealth"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
TIMER_FILE="/etc/systemd/system/${SERVICE_NAME}.timer"
PHP_PATH="$(which php)"


## Check if PHP exists
if [ -z "$PHP_PATH" ] || [ ! -x "$PHP_PATH" ]; then
	echo "PHP is not found in your PATH."
	echo "Unable to continue setup."
	echo "Please install PHP and try again."
	exit 1
fi 

## Create .service File
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=System Health Check

[Service]
Type=oneshot
ExecStart=$PHP_PATH $SCRIPT_PATH
EOF

echo "Service file created $SERVICE_FILE"

## Create .timer file
sudo tee "$TIMER_FILE" > /dev/null <<EOF
[Unit]
Description=Run System Health Check every 7 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=7min
Unit=${SERVICE_NAME}.service

[Install]
WantedBy=timers.target
EOF

echo "Timer file created $TIMER_FILE"

## Reload Systemd, enable and start timer.
sudo systemctl daemon-reload
sudo chmod 755 /etc/systemd/system/${SERVICE_NAME}.*
sudo systemctl enable --now "${SERVICE_NAME}.timer"

echo "syshealh service installed"
echo "Validate service is healthy:"
echo "sudo systemctl status syshealth"
echo "Validate time is installed:"
echo "sudo systemctl list-timers | grep $SERVICE_NAME"
