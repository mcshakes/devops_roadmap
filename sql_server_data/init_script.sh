#!/bin/bash
set -e

# Install updates and Docker
sudo apt-get update -y
sudo apt-get install -y docker.io

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Run SQL Server Express in Docker
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourSecurePassword123' \
-p 1433:1433 --name sqlserver --restart=always \
-d mcr.microsoft.com/mssql/server:2019-latest
