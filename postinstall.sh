#!/bin/bash
set -e  # stop if any command fails

SETUP_DIR="$HOME/ubuntu-setup"

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install apt packages
echo "Installing apt packages..."
sudo apt install -y nala preload vlc flatpak gnome-software-plugin-flatpak gnome-tweaks gnome-shell-extension-manager \
    ubuntu-restricted-extras gparted timeshift synaptic gufw neofetch git git-core zsh curl wget \
    build-essential cmake make gcc g++ nodejs npm gdebi unrar dconf-editor x11-utils

# Remove Snap (if installed)
if command -v snap &> /dev/null; then
    echo "Removing all Snap packages..."
    for pkg in $(snap list 2>/dev/null | awk '!/^Name/ {print $1}'); do
        echo "   → Removing $pkg ..."
        sudo snap remove --purge "$pkg" || true
    done

    echo "Stopping and disabling Snap services..."
    sudo systemctl stop snapd.service 2>/dev/null || true
    sudo systemctl disable snapd.service 2>/dev/null || true
    sudo systemctl stop snapd.socket 2>/dev/null || true
    sudo systemctl disable snapd.socket 2>/dev/null || true
    sudo systemctl stop snapd.seeded.service 2>/dev/null || true
    sudo systemctl disable snapd.seeded.service 2>/dev/null || true

    echo "Removing Snap daemon..."
    sudo apt purge -y snapd || true
    sudo apt autoremove -y
    rm -rf ~/snap /snap /var/snap /var/lib/snapd /var/cache/snapd
    sudo apt-mark hold snapd
else
    echo "Snap not found, skipping removal..."
fi

# Remove unwanted preinstalled apps
echo "Removing unwanted preinstalled apps..."

UNWANTED_APPS=(
    thunderbird
    libreoffice*    # removes all LibreOffice components
    rhythmbox
    cheese          # webcam app
    gnome-mahjongg
    gnome-mines
    gnome-sudoku
    aisleriot       # solitaire
    remmina         # remote desktop
    shotwell
    transmission-gtk
)

for app in "${UNWANTED_APPS[@]}"; do
    if dpkg -l | grep -q "$app"; then
        echo "   → Removing $app ..."
        sudo apt purge -y "$app" || true
        rm -rf "$HOME/.config/$app" || true
        rm -rf "$HOME/.local/share/$app" || true
        rm -rf "$HOME/.cache/$app" || true
    else
        echo "   → $app not installed, skipping."
    fi
done

sudo apt autoremove -y


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
gnome-shell-extension-installer --yes 19 || true     # User Themes
gnome-shell-extension-installer --yes 3193 || true   # Blur My Shell
gnome-shell-extension-installer --yes 3956 || true   # Fuzzy Search
gnome-shell-extension-installer --yes 1319 || true   # GS Connect
gnome-shell-extension-installer --yes 615 || true    # App Indicator
gnome-shell-extension-installer --yes 517 || true    # Caffein

echo "Enabling extensions..."
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
gnome-extensions enable blur-my-shell@aunetx || true
gnome-extensions enable gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com || true
gnome-extensions enable gsconnect@andyholmes.github.io || true
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com || true
gnome-extensions enable caffeine@patapon.info || true

# Custom keyboard shortcut binding
echo "Setting custom GNOME keyboard shortcuts..."
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]" || true

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

# Join array into GVariant format
shortcut_list=$(printf "'%s', " "${shortcuts[@]}")
shortcut_list="[${shortcut_list%, }]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$shortcut_list" || true

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
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" name "$name" || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" command "$cmd" || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" binding "$key" || true
done

echo "Setting workspace switching shortcuts..."
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']" || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']" || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']" || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']" || true

# Cloudflare DNS setup
echo "Setting DNS to Cloudflare..."
nmcli con mod "$(nmcli -t -f NAME con show --active | head -n1)" ipv4.dns "1.1.1.1 1.0.0.1"
nmcli con up "$(nmcli -t -f NAME con show --active | head -n1)"

# Avro keyboard & Default bangla font
echo "Installing Avro Keyboard..."
sudo apt install -y ibus-avro

# Install Fonts
echo "Installing fonts..."
fonts_dir="$( cd "$( dirname "$0" )" && pwd )/fonts"
font_dir="$HOME/.local/share/fonts"
mkdir -p "$font_dir"

if [ -d "$fonts_dir" ]; then
    cp -a "$fonts_dir/." "$font_dir/"
    echo "Fonts copied to $font_dir"
fi

echo "Installing Bangla fonts..."
sudo apt install -y fonts-noto-core fonts-noto-ui-core || true

sudo rm -f /usr/share/fonts/truetype/freefont/FreeSans* || true
sudo rm -f /usr/share/fonts/truetype/freefont/FreeSerif* || true

fc-cache -f -v

# Wallpapers
echo "Adding wallpapers to $HOME/Pictures/Wallpaper..."
mkdir -p "$HOME/Pictures/Wallpaper"

# Script directory
script_dir="$( cd "$( dirname "$0" )" && pwd )"

if [ -d "$script_dir/wallpapers" ]; then
    cp -a "$script_dir/wallpapers/." "$HOME/Pictures/Wallpaper/"
    echo "Wallpapers added successfully!"
else
    echo "No 'wallpapers' folder found in $script_dir, skipping..."
fi

# Install Terminal Profile
echo "Installing Zsh + Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# Install Zsh plugins
mkdir -p ~/.oh-my-zsh/custom/plugins
(cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting || true)
(cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions || true)

# Apply custom configs
cp configs/.zshrc ~/.zshrc || true
cp configs/pixegami-agnoster.zsh-theme ~/.oh-my-zsh/themes/ || true

# Load GNOME Terminal profile
profile_id="fb358fc9-49ea-4252-ad34-1d25c649e633"
dconf load /org/gnome/terminal/legacy/profiles:/:$profile_id/ < configs/terminal_profile.dconf || true

# Add profile to GNOME Terminal list
old_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list 2>/dev/null | tr -d "]")
if [ -z "$old_list" ]; then
    front_list="["
else
    front_list="$old_list, "
fi
new_list="$front_list'$profile_id']"
dconf write /org/gnome/terminal/legacy/profiles:/list "$new_list" || true
dconf write /org/gnome/terminal/legacy/profiles:/default "'$profile_id'" || true

# Switch shell to zsh
chsh -s "$(which zsh)"


# Copy ulility scripts to bin to run from terminal when necessary
echo "Copying utility scripts..."
mkdir -p ~/bin
cp "$SETUP_DIR/scripts/"* ~/bin/ || true
chmod +x ~/bin/*

read -p "Reboot now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
    sudo reboot
fi

