#!/bin/bash

# Exit immediately on any error
set -e

# Prompt for new MySQL root password
read -s -p "Enter new MySQL root password: " MYSQL_ROOT_PASSWORD
echo

echo "🔄 Updating package list..."
sudo apt update

echo "⬇️ Installing MySQL Server..."
sudo apt install -y mysql-server

echo "✅ MySQL installed."

echo "🔐 Securing MySQL root account..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

echo "🌍 Enabling root login from any host..."
sudo mysql -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "🛠️ Updating MySQL config to allow remote connections..."
MYSQL_CNF="/etc/mysql/mysql.conf.d/mysqld.cnf"
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' "$MYSQL_CNF"

echo "🔁 Restarting MySQL..."
sudo systemctl restart mysql

echo "🔥 Checking UFW firewall status..."
if sudo ufw status | grep -q active; then
    echo "✅ UFW is active. Allowing port 3306..."
    sudo ufw allow 3306
else
    echo "⚠️ UFW is not active. Skipping firewall rule."
fi

echo "✅ MySQL installation complete with remote root access."
echo "📌 REMEMBER: Ensure port 3306 is open in your cloud provider (e.g., AWS Security Group)."
echo "📌 You can check MySQL status using: sudo systemctl status mysql"
