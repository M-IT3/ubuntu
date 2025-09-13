#!/bin/bash

# Exit on error
set -e

echo "⚠️ This will completely uninstall MySQL and delete all databases."
read -p "Are you sure? Type YES to continue: " confirm

if [[ "$confirm" != "YES" ]]; then
    echo "❌ Uninstall cancelled."
    exit 1
fi

echo "🧹 Stopping MySQL service..."
sudo systemctl stop mysql || true

echo "📦 Removing MySQL packages..."
sudo apt purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*

echo "🗑️ Removing configuration and database files..."
sudo rm -rf /etc/mysql /var/lib/mysql ~/.mysql

echo "🧼 Removing MySQL user and group (if exists)..."
sudo deluser --remove-home mysql || true
sudo delgroup mysql || true

echo "🧹 Auto-removing unused packages..."
sudo apt autoremove -y
sudo apt autoclean

echo "✅ MySQL has been fully removed from your system."
