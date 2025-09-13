#!/bin/bash

# Exit on error
set -e

# Prompt for root password
read -s -p "Enter new MySQL root password: " MYSQL_ROOT_PASSWORD
echo

echo "🔐 Updating MySQL root password..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

echo "🌍 Allowing root login from any host (not just localhost)..."
sudo mysql -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "🛠️ Updating MySQL config to allow remote connections..."
MYSQL_CNF="/etc/mysql/mysql.conf.d/mysqld.cnf"
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' "$MYSQL_CNF"

echo "🔁 Restarting MySQL..."
sudo systemctl restart mysql

echo "🔥 Opening port 3306 in UFW firewall (if enabled)..."
if sudo ufw status | grep -q active; then
    sudo ufw allow 3306
fi

echo "✅ MySQL root password set and remote access enabled."
echo "📌 IMPORTANT: Ensure your server firewall and cloud provider (AWS, GCP, etc.) allow port 3306."
