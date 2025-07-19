#!/bin/bash

## Full Path to script
SCRIPT_PATH="$(realpath sysHealthCheck.php)"

if [ ! -f "$SCRIPT_PATH" ]; then
	echo "Error sysHealthCheck.php file not found."
	exit 1
fi

## Check if PHP exists
if command -v php >/dev/null 2>&1; then
	echo "PHP is already installed."
	echo $(which php)

else

	if command -v apt >/dev/null 2>&1; then
		echo "Installing PHP"
		sleep 3
		sudo apt install php -y
		echo $(which php)

	elif command -v rpm >/dev/null 2>&1; then
		echo "Installing PHP"
		sleep 3
		sudo cp bin/php /usr/local/bin/php
		echo $(which php)

	else
		echo "Could not detect valid package manager or PHP."
		echo "Please install PHP manually"
		echo "(which php) required working"
		sleep 3
		exit 1
	fi
fi

## Define Service and Time Filenames
SERVICE_NAME="syshealth"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
TIMER_FILE="/etc/systemd/system/${SERVICE_NAME}.timer"
PHP_PATH="$(which php)"

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
