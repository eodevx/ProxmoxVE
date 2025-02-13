#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/eodevx/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Basic Dependencies"
$STD apt-get install -y wget
$STD sudo apt install ffmpeg
$STD sudo apt install p7zip p7zip-full p7zip-rar
$STD sudo apt-get install unzip
msg_ok "Installed Basic Dependencies"

msg_info "Installing Advanced Dependencies"
mkdir -p /opt/multi-downloader-nx
cd /tmp
sudo wget -O /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg
echo "deb [signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/debian/ bookworm main" | sudo tee /etc/apt/sources.list.d/mkvtoolnix.list
sudo apt update

msg_ok "installed Advanced Dependencies"

msg_info "Installing Multi Download NX"
wget https://github.com/anidl/multi-downloader-nx/releases/download/latest/multi-downloader-nx-linux-gui.7z
7z e multi-downloader-nx-linux-gui.7z
mv multi-downloader-nx-linux-gui /opt/multi-downloader-nx
sudo apt install mkvtoolnixwget https://github.com/shaka-project/shaka-packager/releases/download/v3.4.2/packager-linux-x64 -O /opt/multi-downloader-nx/shaka-packager
wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-641.x86_64-unknown-linux.zip -O /tmp/bento4.zip
unzip /tmp/bento4.zip
mv "/tmp/Bento4-SDK-1-6-0-641.x86_64-unknown-linux/bin/mp4decrypt" /opt/multi-downloader-nx/mp4decrypt
cat <<EOF > /opt/multi-downloader-nx/mp4decrypt/config/bin-path.yml
ffmpeg: "ffmpeg"
mkvmerge: "mkvmerge"
ffprobe: "ffprobe"
mp4decrypt: "mp4decrypt"
shaka: "shaka-packager"
EOF

msg_ok "Installed Multi Download NX"
motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
$STD sudo apt remove p7zip p7zip-full p7zip-rar
sudo apt-get remove unzip
msg_ok "Cleaned"
