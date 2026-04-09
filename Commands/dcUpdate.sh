#!/bin/bash
set -e

DEB="/tmp/discord-latest.deb"

echo "Downloading latest Discord..."
wget -O "$DEB" "https://discord.com/api/download/stable?platform=linux&format=deb"

echo "Installing..."
sudo dpkg -i "$DEB"
sudo apt-get install -f -y   # fix any dependency issues

rm -f "$DEB"
echo "Done."
