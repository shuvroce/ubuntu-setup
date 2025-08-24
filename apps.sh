#!/bin/bash
set -e  # stop if any command fails

SETUP_DIR="$HOME/ubuntu-setup"

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

