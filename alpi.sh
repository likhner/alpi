#!/bin/bash
# Name: Arch Linux Post Installation
# Description: The script for the initial setup and installation of all necessary applications on the Arch Linux.
# Author: Arthur Likhner <arthur@likhner.com>
# License: No License (No Permission)
# Last change: 25.12.2020

echo "Arch Linux Post Installation"


echo "Setting up DNS"
echo "nameserver 1.1.1.1
nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf
echo "Done"
clear


echo "Setting up NTP"
sudo sed -i -e 's/#NTP=/NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org/g' /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
echo "Done"
clear


echo "Installing the mirrorlist"
sudo pacman --noconfirm -Suy
sudo pacman --noconfirm -S pacman-contrib
sudo curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on"
sudo sed -i -e 's/#Server/Server/g' /etc/pacman.d/mirrorlist
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.org
sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.org | sudo tee -a /etc/pacman.d/mirrorlist
sudo rm -rf /etc/pacman.d/mirrorlist.org
sudo pacman --noconfirm -Rs pacman-contrib
echo "Done"
clear


echo "Start of installation"
sudo pacman --noconfirm -Suy
sudo pacman --noconfirm -S bash-completion xorg-server mesa nvidia-dkms nvidia-utils nvidia-settings intel-ucode gdm net-tools network-manager-applet
echo "Done"
read -p "Press any key to continue"
clear


echo "Disabling DHCPCD and enabling NetworkManager"
sudo systemctl stop dhcpcd@enp3s0.service
sudo systemctl disable dhcpcd@enp3s0.service
sudo systemctl stop dhcpcd.service
sudo systemctl disable dhcpcd.service
sudo pacman --noconfirm -Rs dhcpcd
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
echo "Done"
clear


echo "Adding Russian language support to bash"
echo LANG=ru_RU.UTF-8 | sudo tee -a /etc/locale.conf
echo "Done"
clear


echo "Installation of applications"
sudo sed -i 's/^\(\s*\)#\(\[multilib]\)/\1\2/' /etc/pacman.conf
sudo sed -i "93s/#Include/Include/" /etc/pacman.conf
sudo sed -i -e 's/#Color/Color/g' /etc/pacman.conf
sudo pacman --noconfirm -Suy
sudo pacman --noconfirm -S bind-tools chromium vlc f2fs-tools wget ntfs-3g p7zip unrar unzip pavucontrol gufw xdg-user-dirs linux-zen-headers linux-firmware openssh keepassxc mc qbittorrent telegram-desktop git gvfs-mtp lib32-nvidia-utils gnupg \
fontconfig ttf-hanazono ttf-liberation ttf-ubuntu-font-family sdl2_ttf sdl_ttf ttf-arphic-ukai ttf-arphic-uming ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-anonymous-pro noto-fonts-emoji otf-font-awesome opendesktop-fonts freetype2 \
libdca libmad libvorbis libfdk-aac libde265 libmpeg2 libtheora libvpx x264 x265 xvidcore flac wavpack celt lame a52dec faac faad2 aom openjpeg2 libwebp libjpeg-turbo gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly gstreamer-vaapi gst-plugins-bad \
libgphoto2 gvfs-gphoto2 libmtp udftools gettext acl glu ncurses sdl2 v4l-utils vkd3d gcc-libs libnl libpcap libtiff libusb libxcursor libxrandr libxrender lz4 zstd libsm libxdamage libxi libxml2 alsa-lib alsa-plugins giflib gnutls libldap libpng libpulse libxcomposite libxinerama libxslt \
chrome-gnome-shell gnome-control-center gnome-screenshot gnome-shell gnome-system-monitor gnome-tweaks nautilus evince eog baobab gnome-disk-utility gnome-calculator file-roller gedit seahorse ccid pcsc-tools
echo "Done"
read -p "Press any key to continue"
clear


echo "Enabling ID card support"
sudo systemctl enable pcscd.socket
sudo systemctl start pcscd.socket
echo "Done"
clear


echo "Setting up firewall"
sudo systemctl enable ufw.service
sudo systemctl start ufw.service
echo "Done"
clear


echo "Adding Blu-ray support to VLC"
sudo pacman --noconfirm -S libaacs
mkdir ~/.config/aacs
curl -o ~/.config/aacs/KEYDB.cfg "https://gist.githubusercontent.com/likhner/822ccba36c9c88df3975c357c9310642/raw/KEYDB.cfg"
echo "Done"
clear


echo "Adding Cyrillic support to gedit"
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
echo "Done"
clear


echo "Enabling optimization of streaming"
sudo sh -c "echo '__GL_THREADED_OPTIMIZATIONS=1' >> /etc/profile"
sudo sh -c "echo '__GL_SHADER_DISK_CACHE=1' >> /etc/profile"
sudo sh -c "echo '__GL_SHADER_DISK_CACHE_PATH=/tmp/' >> /etc/profile"
echo "Done"
clear


echo "Setting up Chromium"
sudo mkdir /etc/chromium
sudo mkdir /etc/chromium/policies
sudo mkdir /etc/chromium/policies/managed
echo '{
    "ExtensionInstallForcelist": [
        // uBlock Origin
        "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx",
        // HTTPS Everywhere
        "gcbommkclmclpchllfjekcdonpmejbdp;https://clients2.google.com/service/update2/crx",
        // Privacy Badger
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx",
        // WebRTC Control
        "fjkmabmdepjfammlpliljpnbhleegehm;https://clients2.google.com/service/update2/crx",
        // AutoScroll
        "occjjkgifpmdgodlplnacmkejpdionan;https://clients2.google.com/service/update2/crx",
        // GNOME Shell integration
        "gphhapmejobijbbhgpjhcjognlahblep;https://clients2.google.com/service/update2/crx",
        // Decentraleyes
        "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx",
        // Just Black
        "aghfnjkcakhmadgdomlmlhhaocbkloab;https://clients2.google.com/service/update2/crx",
        // Google search link fix
        "cekfddagaicikmgoheekchngpadahmlf;https://clients2.google.com/service/update2/crx",
        // LanguageTool
        "oldceeleldhonbafppcapldpdifcinji;https://clients2.google.com/service/update2/crx",
        // Dont add custom search engines
        "dnodlcololidkjgbpeoleabmkocdhacc;https://clients2.google.com/service/update2/crx",
    ],
    "SSLVersionMin": "tls1.2"
}' | sudo tee -a /etc/chromium/policies/managed/policies.json
echo "Done"
clear


echo "Installation of Yay and application from AUR"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -Rfv yay/
read -p "Press any key to continue"
yay -S --noconfirm exfat-linux-dkms exfat-utils-nofuse spotify notion-app la-capitaine-icon-theme-git qogir-gtk-theme-git gnome-terminal-transparency eparakstitajs3 eparaksts-token-signing latvia-eid-middleware
echo "Done"
read -p "Press any key to continue"
clear


echo "Cache cleaning and removal of unused packages"
sudo pacman --noconfirm -Rns $(sudo pacman --noconfirm -Qtdq)
sudo pacman -Scc --noconfirm
yay -Scc --noconfirm
rm -rf ~/.cache/*
sudo rm -rf /tmp/*
sudo rm -rf /root/.cache/*
sudo rm /root/.bash_history
echo "Done"
read -p "Press any key to continue"
clear


echo "Installation is over! Continue to configure the system yourself!"
read -p "Press any key to continue"
sudo systemctl enable gdm.service
sudo systemctl start gdm.service
clear

# GNOME Extensions: https://extensions.gnome.org/extension/15/alternatetab/ https://extensions.gnome.org/extension/307/dash-to-dock/ https://extensions.gnome.org/extension/8/places-status-indicator/ https://extensions.gnome.org/extension/7/removable-drive-menu/ https://extensions.gnome.org/extension/1112/screenshot-tool/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/355/status-area-horizontal-spacing/ https://extensions.gnome.org/extension/1674/topiconsfix/ https://extensions.gnome.org/extension/1080/transparent-notification/ https://extensions.gnome.org/extension/1073/transparent-osd/ https://extensions.gnome.org/extension/277/impatience/
