#!/bin/bash
# remove-app.sh — Universal app remover for Debian (deb + flatpak + snap)

FLATPAK_CMD=$(command -v flatpak)
SNAP_CMD=$(command -v snap)
DPKG_CMD=$(command -v dpkg)

# Flatpak removal
if $FLATPAK_CMD list --app | awk '{print $1}' | grep -q "^$APP$"; then
    echo "Found $APP as Flatpak app. Removing..."
    $FLATPAK_CMD uninstall -y "$APP"
    $FLATPAK_CMD uninstall --unused -y
    rm -rf ~/.var/app/"$APP"
    echo "✔ $APP (Flatpak) completely removed."
    exit 0
fi

# Snap removal
if $SNAP_CMD list | awk '{print $1}' | grep -q "^$APP$"; then
    echo "Found $APP as Snap package. Removing..."
    sudo $SNAP_CMD remove "$APP"
    sudo $SNAP_CMD remove --purge "$APP" 2>/dev/null
    rm -rf ~/snap/"$APP"
    echo "✔ $APP (Snap) completely removed."
    exit 0
fi

# .deb removal
if $DPKG_CMD -l | grep -q "^ii\s\+$APP"; then
    echo "Found $APP as .deb package. Removing..."
    sudo apt purge -y "$APP"
    rm -rf ~/.config/"$APP" ~/.local/share/"$APP" ~/.cache/"$APP"
    echo "✔ $APP (.deb) completely removed."
    exit 0
fi

echo "App '$APP' not found as .deb, Flatpak, or Snap."

