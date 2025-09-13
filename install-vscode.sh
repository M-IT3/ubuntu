#!/bin/bash

# Exit on error
set -e

echo "Updating package list..."
sudo apt update

echo "Installing required dependencies..."
sudo apt install -y wget gpg

echo "Downloading Microsoft GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

echo "Installing GPG key..."
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

echo "Adding VS Code repository..."
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

echo "Updating package list again..."
sudo apt update

echo "Installing Visual Studio Code..."
sudo apt install -y code

echo "Cleaning up..."
rm packages.microsoft.gpg

echo "✅ Visual Studio Code installed successfully!"
