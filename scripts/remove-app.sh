#!/bin/bash
# remove-app.sh — Universal app remover for Debian (deb + flatpak + snap)

APP="$1"

if [ -z "$APP" ]; then
    echo "Usage: $0 <app-name or flatpak-id or snap-name>"
    exit 1
fi

# --- Try .deb package removal ---
if dpkg -l | grep -q "^ii  $APP "; then
    echo "Found $APP as .deb package. Removing..."
    sudo apt purge -y "$APP"
    sudo apt autoremove -y
    rm -rf ~/.config/"$APP" ~/.local/share/"$APP" ~/.cache/"$APP"
    echo "✔ $APP (.deb) completely removed."
    exit 0

# --- Try Flatpak app removal ---
elif flatpak list --app --columns=application | grep -q "^$APP$"; then
    echo "Found $APP as Flatpak app. Removing..."
    flatpak uninstall -y "$APP"
    flatpak uninstall --unused -y
    rm -rf ~/.var/app/"$APP"
    echo "✔ $APP (Flatpak) completely removed."
    exit 0

# --- Try Snap app removal ---
elif command -v snap >/dev/null 2>&1 && snap list | awk '{print $1}' | grep -q "^$APP$"; then
    echo "Found $APP as Snap package. Removing..."
    sudo snap remove "$APP"
    # Snap sometimes leaves revisions → cleanup
    sudo snap remove --purge "$APP" 2>/dev/null
    rm -rf ~/snap/"$APP"
    echo "✔ $APP (Snap) completely removed."
    exit 0
else
    echo "App '$APP' not found as .deb, Flatpak, or Snap."
    exit 1
fi
