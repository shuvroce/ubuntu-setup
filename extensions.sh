#!/bin/bash
set -e  # stop if any command fails

SETUP_DIR="$HOME/ubuntu-setup"

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
gnome-shell-extension-installer --yes 1369 || true   # Add to Desktop
gnome-shell-extension-installer --yes 3204 || true   # ESC Overview
gnome-shell-extension-installer --yes 1337 || true   # Show Apps instead of Workspaces
gnome-shell-extension-installer --yes 355 || true    # Status area horizontal spacing
gnome-shell-extension-installer --yes 7 || true      # Drive menu
gnome-shell-extension-installer --yes 7565 || true   # Netspeed monitor
gnome-shell-extension-installer --yes 2645 || true   # Brightness control
gnome-shell-extension-installer --yes 3843 || true   # Just Perfection
gnome-shell-extension-installer --yes 7048 || true   # Rounded Corners
gnome-shell-extension-installer --yes 5489 || true   # Search Light
gnome-shell-extension-installer --yes 4356 || true   # Top bar organizer
gnome-shell-extension-installer --yes 779 || true    # Clipboard indicator

echo "Enabling extensions..."
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
gnome-extensions enable blur-my-shell@aunetx || true
gnome-extensions enable gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com || true
# gnome-extensions enable gsconnect@andyholmes.github.io || true
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com || true
gnome-extensions enable caffeine@patapon.info || true
gnome-extensions enable add-to-desktop@tommimon.github.com || true
gnome-extensions enable escape-overview@raelgc || true
gnome-extensions enable show_applications_instead_of_overview@fawtytoo || true
gnome-extensions enable status-area-horizontal-spacing@mathematical.coffee.gmail.com || true
gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com || true
gnome-extensions enable netspeed-monitor@ajxv || true
gnome-extensions enable display-brightness-ddcutil@themightydeity.github.com || true
gnome-extensions enable just-perfection-desktop@just-perfection || true
gnome-extensions enable rounded-window-corners@fxgn || true
gnome-extensions enable search-light@icedman.github.com || true
gnome-extensions enable top-bar-organizer@julian.gse.jsts.xyz || true
# gnome-extensions enable clipboard-indicator@tudmotu.com || true