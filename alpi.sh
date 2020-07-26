#!/bin/bash
# Name: Arch Linux Post Installation
# Description: The script for the initial setup and installation of all necessary applications on the Arch Linux.
# Author: Arthur Likhner <arthur@likhner.com>
# License: No License (No Permission)
# Last change: 26.07.2020

echo "Arch Linux Post Installation"


echo "DNS Setup"
echo "nameserver 1.1.1.1
nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf
echo "Done"
clear


echo "NTP setup"
sudo sed -i -e 's/#NTP=/NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org/g' /etc/systemd/timesyncd.conf
sudo timedatectl set-ntp true
echo "Done"
clear


echo "Install mirrorlist"
sudo curl -o /etc/pacman.d/mirrorlist "https://www.archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on"
sudo sed -i -e 's/#Server/Server/g' /etc/pacman.d/mirrorlist
echo "Done"
clear


echo "Installation start"
sudo pacman --noconfirm -Suy
sudo pacman --noconfirm -S bash-completion xorg-server xorg-apps xorg-xinit mesa xorg-twm xterm xorg-xclock nvidia nvidia-utils nvidia-settings intel-ucode gdm net-tools network-manager-applet
echo "Done"
read -p "Press any key to continue"
clear


echo "Off Wayland in GDM (because Wayland performance is low with nVidia)"
sudo sed -i -e 's/#WaylandEnable=false/WaylandEnable=false/g' /etc/gdm/custom.conf
echo "Done"
clear


echo "Off DHCP and enable NetworkManager"
sudo systemctl stop dhcpcd@enp3s0.service
sudo systemctl disable dhcpcd@enp3s0.service
sudo systemctl stop dhcpcd.service
sudo systemctl disable dhcpcd.service
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
echo "Done"
clear


echo "Enable Russian in bash"
echo LANG=ru_RU.UTF-8 | sudo tee -a /etc/locale.conf
echo "Done"
clear


echo "Software installation"
sudo sed -i 's/^\(\s*\)#\(\[multilib]\)/\1\2/' /etc/pacman.conf
sudo sed -i "93s/#Include/Include/" /etc/pacman.conf
sudo sed -i -e 's/#Color/Color/g' /etc/pacman.conf
sudo pacman --noconfirm -Suy
sudo pacman --noconfirm -S chrome-gnome-shell bind-tools seahorse chromium baobab dnscrypt-proxy keybase keybase-gui fakeroot evince eog vlc f2fs-tools gnome-disk-utility gnome-calculator file-roller firefox-i18n-ru youtube-dl gedit gimp gnome-control-center gnome-screenshot gnome-shell gnome-system-monitor gnome-tweaks nautilus wget ntfs-3g p7zip unrar unzip pavucontrol pepper-flash flashplugin gufw rhythmbox whois xdg-user-dirs linux-headers openssh electrum code bleachbit keepassxc mc ponysay pavucontrol-qt qbittorrent telegram-desktop tor virtualbox git neofetch gvfs-mtp gvfs-gphoto2 libmtp noto-fonts-emoji sdl2_ttf sdl_ttf ttf-arphic-ukai ttf-arphic-uming ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid otf-font-awesome opendesktop-fonts ttf-anonymous-pro ttf-hanazono ttf-liberation ttf-ubuntu-font-family lib32-sdl2_ttf lib32-sdl_ttf lib32-mesa-libgl libdca libmad libmpcdec libvorbis libfdk-aac libde265 libdv libmpeg2 libtheora libvpx gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly x264 x265 xvidcore openjpeg2 udftools flac wavpack celt lame a52dec faac faad2 jasper fontconfig freetype2 gettext acl glu ncurses sdl2 v4l-utils vkd3d desktop-file-utils lcms2 gcc-libs libjpeg-turbo libnl libpcap libtiff libusb libxcursor libxrandr libxrender lz4 zstd lib32-acl lib32-fontconfig lib32-gettext lib32-glu lib32-lcms2 lib32-libjpeg-turbo lib32-libnl lib32-libpcap lib32-libtiff lib32-libusb lib32-libxcursor lib32-nvidia-utils lib32-libxrandr lib32-libxrender lib32-lz4 lib32-zstd lib32-freetype2 lib32-gcc-libs lib32-libsm lib32-libxdamage lib32-libxi lib32-libxml2 libsm libxdamage libxi libxml2 alsa-lib alsa-plugins giflib gnutls lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs lib32-libldap lib32-libpng lib32-libpulse lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-mpg123 lib32-ncurses lib32-openal lib32-opencl-icd-loader lib32-sdl2 lib32-v4l-utils lib32-vkd3d libgphoto2 libldap libpng libpulse libxcomposite libxinerama libxslt opencore-amr speex aom schroedinger
echo "Done"
read -p "Press any key to continue"
clear


echo "Configure DNSCrypt"
sudo curl -o /etc/dnscrypt-proxy/dnscrypt-proxy.toml "https://raw.githubusercontent.com/likhner/configs/master/dnscrypt-proxy.toml"
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy.service
echo "Done"
clear


echo "Adding Cyrillic support to gedit"
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
echo "Done"
clear


echo "Set .bashrc"
echo "

sudo ifconfig enp3s0 down
sudo ifconfig enp3s0 hw ether `hexdump -n 6 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s:%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}'`
sudo ifconfig enp3s0 up

ifconfig -a | grep ether | gawk '{print $2}'

yay -Syu

uname -a | ponysay -f blaze" >> ~/.bashrc
echo "Done"
clear


echo "Enable streaming optimization"
sudo sh -c "echo '__GL_THREADED_OPTIMIZATIONS=1' >> /etc/profile"
sudo sh -c "echo '__GL_SHADER_DISK_CACHE=1' >> /etc/profile"
sudo sh -c "echo '__GL_SHADER_DISK_CACHE_PATH=/tmp/' >> /etc/profile"
echo "Done"
clear


echo "Chromium Setup"
sudo mkdir /etc/chromium
sudo mkdir /etc/chromium/policies
sudo mkdir /etc/chromium/policies/managed
echo '{
    "ExtensionInstallForcelist": [
        // uBlock Origin
        "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx",
        // Privacy Possum
        "ommfjecdpepadiafbnidoiggfpbnkfbj;https://clients2.google.com/service/update2/crx",
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
        "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx"
    ],
    "SSLVersionMin": "tls1.2",
    "DnsOverHttpsMode": "secure",
    "DnsOverHttpsTemplates": "https://1.1.1.1/dns-query"
}' | sudo tee -a /etc/chromium/policies/managed/policies.json
echo "Done"
clear


echo "Firefox Setup"
sudo curl -o /usr/lib64/firefox/browser/defaults/preferences/autoconfig.js "https://raw.githubusercontent.com/likhner/configs/master/Firefox/autoconfig.js"
sudo curl -o /usr/lib64/firefox/distribution/policies.json "https://raw.githubusercontent.com/likhner/configs/master/Firefox/policies.json"
echo "Done"
clear


echo "Install Yay and AUR software"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -Rfv yay/
read -p "Press any key to continue"
yay -S --noconfirm balena-etcher exfat-linux-dkms exfat-utils-nofuse firebase-tools anydesk la-capitaine-icon-theme pamac-aur qogir-gtk-theme-git rukbi spotify gnome-terminal-transparency realtek-firmware 
sudo /usr/share/X11/xkb/rukbi/install/install
echo "Done"
read -p "Press any key to continue"
clear


echo "Clearing the cache and removing unused packages"
sudo pacman --noconfirm -Rns $(sudo pacman --noconfirm -Qtdq)
yay -Sc --noconfirm
rm -rf ~/.cache/*
sudo rm -rf /tmp/*
sudo rm -rf /root/.cache/*
sudo rm /root/.bash_history
echo "Done"
read -p "Press any key to continue"
clear


echo "Installation is over! Continue to configure the system yourself, and do not forget to see the link in the ALPI file!"
read -p "Press any key to continue"
sudo systemctl enable gdm
sudo systemctl start gdm
clear


# GNOME Extensions: https://extensions.gnome.org/extension/15/alternatetab/ https://extensions.gnome.org/extension/307/dash-to-dock/ https://extensions.gnome.org/extension/8/places-status-indicator/ https://extensions.gnome.org/extension/7/removable-drive-menu/ https://extensions.gnome.org/extension/1112/screenshot-tool/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/355/status-area-horizontal-spacing/ https://extensions.gnome.org/extension/1674/topiconsfix/ https://extensions.gnome.org/extension/1080/transparent-notification/ https://extensions.gnome.org/extension/1073/transparent-osd/ https://extensions.gnome.org/extension/277/impatience/