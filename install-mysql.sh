#!/bin/bash

# Exit on error
set -e

echo "🔄 Updating package list..."
sudo apt update

echo "⬇️ Installing MySQL Server..."
sudo apt install -y mysql-server

echo "✅ MySQL installed."

echo "🔐 Securing MySQL installation..."
sudo mysql_secure_installation

echo "✅ MySQL secure installation complete."

echo "📌 You can check MySQL status using: sudo systemctl status mysql"
