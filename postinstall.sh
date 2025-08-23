#!/bin/bash
set -e  # stop if any command fails

SETUP_DIR="$HOME/ubuntu-setup"

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install apt packages
echo "Installing apt packages..."
sudo apt install -y nala preload vlc flatpak gnome-software-plugin-flatpak gnome-tweaks gnome-shell-extension-manager \
    ubuntu-restricted-extras gparted timeshift synaptic gufw neofetch git curl wget \
    build-essential cmake make gcc g++ nodejs npm gdebi unrar dconf-editor x11-utils

# Remove snap
echo "Removing all Snap packages..."
for pkg in $(snap list | awk '!/^Name/ {print $1}'); do
    echo "   → Removing $pkg ..."
    sudo snap remove --purge "$pkg"
done

echo "Stopping and disabling Snap services..."
sudo systemctl stop snapd.service
sudo systemctl disable snapd.service
sudo systemctl stop snapd.socket
sudo systemctl disable snapd.socket
sudo systemctl stop snapd.seeded.service
sudo systemctl disable snapd.seeded.service

echo "Removing Snap daemon..."
sudo apt purge snapd -y
sudo apt autoremove -y
rm -rf ~/snap /snap /var/snap /var/lib/snapd /var/cache/snapd
sudo apt-mark hold snapd

# Install firefox deb version
echo "Installing Firefox (Deb version)..."
sudo add-apt-repository -y ppa:mozillateam/ppa

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

echo '
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee -a /etc/apt/preferences.d/mozilla-firefox

sudo apt update
sudo apt install -y firefox

# Set-up flatpak & Install Flatpak apps
echo "Setting up Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak_apps=(
    "io.github.debasish_patra_1987.linuxthemestore" 
    "com.discordapp.Discord"
    "org.telegram.desktop"
    "org.gimp.GIMP"
    "org.bleachbit.BleachBit"
    "com.obsproject.Studio"
    "org.libreoffice.LibreOffice"
    "com.usebottles.bottles"
    "org.gnome.World.PikaBackup"
    "org.zotero.Zotero"
    "com.spotify.Client"
    "com.sindresorhus.Caprine"
    "garden.jamie.Morphosis"
    "io.github.josephmawa.Bella"
    "com.belmoussaoui.Authenticator"
    "net.codelogistics.webapps"
    "org.gnome.Decibels"
    "org.mozilla.vpn"
    "app.drey.Dialect"
    "com.hunterwittenborn.Celeste"
    "io.github.david_swift.Flashcards"
    "us.zoom.Zoom"
    # ...other apps
)

for app in "${flatpak_apps[@]}"; do
    echo "Installing Flatpak app: $app"
    flatpak install -y flathub "$app" || true
done

# Install local deb apps
echo "Installing local .deb files..."
if [ -d "$SETUP_DIR/deb" ]; then
    for deb in "$SETUP_DIR"/deb/*.deb; do
        [ -f "$deb" ] && sudo apt install -y "$deb"
    done
fi

# Restore general settings
echo "Restoring GNOME settings & keybindings from backup (if available)..."
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

if [ -f "$SETUP_DIR/dconf/gnome-settings.conf" ]; then
    dconf load / < "$SETUP_DIR/dconf/gnome-settings.conf"
else
    echo "GNOME dconf backup not found in $SETUP_DIR/dconf/"
fi

# Install gnome extensions
echo "Installing GNOME extension installer..."
sudo wget -O /usr/local/bin/gnome-shell-extension-installer \
    https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer
sudo chmod +x /usr/local/bin/gnome-shell-extension-installer

# add all the others necessay extensions
echo "Installing GNOME Extensions..."
gnome-shell-extension-installer --yes 5173   # Fuzzy search
gnome-shell-extension-installer --yes 3193   # Blur My Shell

echo "Enabling extensions..."
gnome-extensions enable fuzzy-app-search@gnome-shell-extensions.2nv2u.com
gnome-extensions enable blur-my-shell@aunetx

# Custom keyboard shortcut binding
echo "Setting custom GNOME keyboard shortcuts..."
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]"

shortcuts=(
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom8/"
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9/"
)

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${shortcuts[@]}"

declare -A custom_shortcuts=(
    ["${shortcuts[0]}"]="Browser firefox '<Super>b'"
    ["${shortcuts[1]}"]="VSCode code '<Super>c'"
    ["${shortcuts[2]}"]="File Explorer nautilus '<Super>e'"
    ["${shortcuts[3]}"]="Terminal gnome-terminal '<Super>t'"
    ["${shortcuts[4]}"]="Settings gnome-control-center '<Super>s'"
    # ["${shortcuts[5]}"]="Clipboard gnome-text-editor '<Super>v'"
    ["${shortcuts[6]}"]="Resource Monitor gnome-system-monitor '<Super>r'"
    ["${shortcuts[7]}"]="Extension Manager gnome-extensions-app '<Super>x'"
    ["${shortcuts[8]}"]="Text Editor gnome-text-editor '<Super>n'"
    ["${shortcuts[9]}"]="Quit Program xkill '<Super>q'"
)

for path in "${!custom_shortcuts[@]}"; do
    IFS=$' ' read -r name cmd key <<< "${custom_shortcuts[$path]}"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" command "$cmd"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" binding "$key"
done

echo "Setting workspace switching shortcuts..."
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"

# Cloudflare DNS setup
echo "Setting DNS to Cloudflare..."
nmcli con mod "$(nmcli -t -f NAME con show --active | head -n1)" ipv4.dns "1.1.1.1 1.0.0.1"
nmcli con up "$(nmcli -t -f NAME con show --active | head -n1)"

# Avro keyboard & Default bangla font
echo "Installing Avro Keyboard..."
sudo apt install -y ibus-avro

echo "Setting default Bangla font..."
sudo apt install fonts-noto-core
sudo apt install fonts-noto-ui-core

sudo rm -f /usr/share/fonts/truetype/freefont/FreeSans*
sudo rm -f /usr/share/fonts/truetype/freefont/FreeSerif*

fc-cache -f -v

# Copy ulility scripts to bin to run from terminal when necessary
echo "Copying utility scripts..."
mkdir -p ~/bin
cp "$SETUP_DIR/scripts/"* ~/bin/ || true
chmod +x ~/bin/*

echo "Setup complete! Please reboot."
