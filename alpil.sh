#!/bin/bash
# Name: Arch Linux Post Installation for Laptops
# Description: The script for the initial setup and installation of all necessary applications on the Arch Linux for Notebook with Intel video cards only and Wi-Fi module.
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
sudo pacman --noconfirm -S bash-completion xorg-server xorg-apps xorg-xinit xorg-twm xterm xorg-xclock intel-ucode lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings net-tools network-manager-applet xf86-input-synaptics wpa_supplicant dhclient iw xf86-video-intel
echo "Done"
read -p "Press any key to continue"
clear


echo "Off DHCP and enable NetworkManager"
sudo systemctl stop dhcpcd@enp9s0.service
sudo systemctl stop dhcpcd@wlp12s0.service
sudo systemctl disable dhcpcd@enp9s0.service
sudo systemctl disable dhcpcd@wlp12s0.service
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
sudo pacman --noconfirm -S bind-tools f2fs-tools dnscrypt-proxy firefox-i18n-ru epdfview chromium htop youtube-dl light-locker vlc xfce4-notifyd ristretto xfce4 xfburn tlp mousepad xfce4-xkb-plugin xfce4-whiskermenu-plugin xarchiver galculator xfce4-terminal gparted arc-gtk-theme rhythmbox qbittorrent xfce4-settings xfce4-taskmanager xfce4-weather-plugin xfce4-screenshooter xfce4-power-manager xfce4-mount-plugin xfce4-pulseaudio-plugin thunar-archive-plugin thunar-media-tags-plugin thunar-volman gimp wget ntfs-3g p7zip unrar git unzip pavucontrol pepper-flash flashplugin gufw rhythmbox whois xdg-user-dirs linux-headers openssh code bleachbit keepassxc mc pavucontrol-qt neofetch gvfs-mtp gvfs-gphoto2 libmtp noto-fonts-emoji sdl2_ttf sdl_ttf ttf-arphic-ukai ttf-arphic-uming ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid otf-font-awesome opendesktop-fonts ttf-anonymous-pro ttf-hanazono ttf-liberation ttf-ubuntu-font-family lib32-sdl2_ttf lib32-sdl_ttf lib32-mesa-libgl libdca libmad libmpcdec libvorbis libfdk-aac libde265 libdv libmpeg2 libtheora libvpx gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly x264 x265 xvidcore openjpeg2 udftools flac wavpack celt lame a52dec faac faad2 jasper fontconfig freetype2 gettext acl glu ncurses sdl2 v4l-utils vkd3d desktop-file-utils lcms2 gcc-libs libjpeg-turbo libnl libpcap libtiff libusb libxcursor libxrandr libxrender lz4 zstd lib32-acl lib32-fontconfig lib32-gettext lib32-glu lib32-lcms2 lib32-libjpeg-turbo lib32-libnl lib32-libpcap lib32-libtiff lib32-libusb lib32-libxcursor lib32-libxrandr lib32-libxrender lib32-lz4 lib32-zstd lib32-freetype2 lib32-gcc-libs lib32-libsm lib32-libxdamage lib32-libxi lib32-libxml2 libsm libxdamage libxi libxml2 alsa-lib alsa-plugins giflib gnutls lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs lib32-libldap lib32-libpng lib32-libpulse lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-mpg123 lib32-ncurses lib32-openal lib32-opencl-icd-loader lib32-sdl2 lib32-v4l-utils lib32-vkd3d libgphoto2 libldap libpng libpulse libxcomposite libxinerama libxslt opencore-amr speex aom schroedinger
echo "Done"
read -p "Press any key to continue"
clear


echo "Configure DNSCrypt"
sudo curl -o /etc/dnscrypt-proxy/dnscrypt-proxy.toml "https://raw.githubusercontent.com/likhner/configs/master/dnscrypt-proxy.toml"
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy.service
echo "Done"
clear


echo "Enable TLP"
sudo systemctl enable tlp
sudo systemctl start tlp
echo "Done"
clear


echo "Set .bashrc"
echo "

sudo ifconfig enp9s0 down
sudo ifconfig wlp12s0 down
sudo ifconfig enp9s0 hw ether `hexdump -n 6 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s:%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}'`
sudo ifconfig wlp12s0 hw ether `hexdump -n 6 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s:%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}'`
sudo ifconfig enp9s0 up
sudo ifconfig wlp12s0 up


ifconfig -a | grep ether | gawk '{print $2}'

yay -Syu

echo Welcome!" >> ~/.bashrc
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
yay -S --noconfirm balena-etcher exfat-linux-dkms exfat-utils-nofuse la-capitaine-icon-theme pamac-aur-git rukbi woeusb
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


echo "Installation is over! Continue to configure the system yourself!"
read -p "Press any key to continue"
sudo systemctl enable lightdm
sudo systemctl start lightdm
clear