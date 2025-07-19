#! /bin/bash

## Define Service and Time Filenames
SERVICE_NAME="syshealthserver"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
SCRIPT_PATH="$(realpath sysHealthCheckServer.php)"
PHP_PATH="$(which php)"
PORT=8186

if [ ! -x "$PHP_PATH" ]; then
	echo "PHP not found, please install PHP first."
	echo "install_health_check_service.sh script will attempt a PHP install"
	exit 1
fi

## Create .service File                                                         
sudo tee "$SERVICE_FILE" > /dev/null <<EOF                                      
[Unit]                                                                          
Description=System Health Check JSON Server
After=network.target                                                 
                                                                                
[Service]                                                                       
Type=simple
User=nobody
ExecStart=$PHP_PATH -S 0.0.0.0:$PORT $SCRIPT_PATH
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
                                                                           
echo "Service file created $SERVICE_FILE"  
sudo systemctl daemon-reload
sudo systemctl enable --now "$SERVICE_NAME"

echo "Systemd Service '$SERVICE_NAME' installed and started."
echo "You can access your health check at: http://localhost/healthcheck.json"
