# Ubuntu Setup Automation

This repository contains a **post-installation automation script** for Ubuntu (GNOME) that installs your preferred software, sets system settings, configures GNOME extensions, applies keyboard shortcuts, sets Bengali fonts, removes Snap, and prepares a ready-to-use development and multimedia environment.


## Features

* Fully **automated setup** after a fresh Ubuntu installation.
* Removes **Snap** and installs the **Debian Firefox** version.
* Installs essential **APT packages** and developer tools.
* Installs **Flatpak apps** (Discord, Telegram, GIMP, OBS, LibreOffice, Zoom, and more).
* Sets up **GNOME extensions** and **keyboard shortcuts**.
* Configures **workspace shortcuts** (Super+1..4).
* Sets **Cloudflare DNS**.
* Installs **Bengali fonts** and **Avro Keyboard**.
* Copies **custom scripts** to `/usr/local/bin` and makes them executable.
* Applies **GNOME settings from dconf backup**.


## Directory Structure

```
ubuntu-setup/
├── configs/           # Terminal profile config file
├── fonts/
├── deb/               # Local .deb packages (VSCode, IntelliJ IDEA, etc.)
├── dconf/             # GNOME dconf backup for settings
│   └── gnome-settings.conf
├── scripts/           # Custom scripts to copy to /usr/local/bin
├── wallpapers/        # Wallpapers to copy to ~/Pictures/Wallpaper
└── postinstall.sh     # Main automation script
```


## Prerequisites

* Fresh Ubuntu installation with **GNOME** desktop.
* Internet connection.
* git installed
* Optional: local `.deb` packages in `ubuntu-setup/deb`.

### Install Git
```bash
sudo apt install git -y
```

## Usage

1. Clone or copy the repository to your home folder:

```bash
git clone https://github.com/shuvroce/ubuntu-setup.git ~/ubuntu-setup
```

2. Make the script executable:

```bash
chmod +x ~/ubuntu-setup/postinstall.sh
```

3. Run the script:

```bash
~/ubuntu-setup/postinstall.sh
```

> The script uses `sudo` for package installation, system configuration, and Snap removal. You may be prompted for your password multiple times.

4. After completion, **reboot** the system to apply all GNOME settings and extensions.


## Customizations

### GNOME Extensions

* Fuzzy Search
* Blur My Shell
* Dash-to-Dock (minimize on click)

### Keyboard Shortcuts

| Shortcut                | Action                          |
| ----------------------- | ------------------------------- |
| Win + B                 | Browser                         |
| Win + C                 | VS Code                         |
| Win + E                 | File Explorer                   |
| Win + T                 | Terminal                        |
| Win + S                 | Settings                        |
| Win + R                 | Resource Monitor / Task Manager |
| Win + X                 | Extension Manager               |
| Win + N                 | Notepad / Text Editor           |
| Win + Q                 | Quit Program                    |
| Win + 1..4              | Switch to Workspace 1..4        |

### DNS

* Sets **Cloudflare DNS** (1.1.1.1, 1.0.0.1) for the active network connection.

### Fonts

* Installs **Noto Sans Bengali** and **Noto UI fonts**.
* Removes conflicting `FreeSans` / `FreeSerif`.
* Configures **default Bengali font** for GNOME UI.
* Installs **Avro Keyboard**.


## Flatpak Apps

Installed from **Flathub**:

* Linux Theme Store
* Discord
* Telegram
* GIMP
* BleachBit
* OBS Studio
* LibreOffice
* Bottles
* Pika Backup
* Zotero
* Spotify
* Zoom

> Apps that fail to install will not stop the script.


## Local .deb Packages

Place your `.deb` files in `ubuntu-setup/deb/` and the script will install them automatically.


## Utility Scripts

Any scripts placed in `ubuntu-setup/scripts/` will be copied to `~/bin` and made executable, allowing you to run them as commands.

## Uninstall/Remove apps completely (deb/flatpak)
* To remove deb app completely, run the script from terminal:

```bash
./remove-app.sh <package-name>      # Ex - firefox-esr
```

* To remove flatpak app completely, run the script from terminal:

```bash
./remove-app.sh <package-id>        # Ex - org.mozilla.firefox
```

## Terminal Profile
For a posh teminal profile, follow instruction from:

```bash
https://github.com/pixegami/terminal-profile
```

## Configure Firefox profile
For Firefox profile, visit:

```bash
https://ffprofile.com/ to config firefox
```

## Notes

* The script **holds Snap** to prevent Ubuntu from reinstalling it.
* Flatpak app installation failures are ignored (`|| true`) to ensure the script continues.
* GNOME settings are applied from `dconf` backup if available.
* The script is meant for **fresh Ubuntu installations**; running it multiple times is safe but may reinstall packages.

