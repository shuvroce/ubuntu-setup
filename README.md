# Ubuntu Setup Automation

This repository contains a **post-installation automation script** for Ubuntu (GNOME) that installs your preferred software, sets system settings, configures GNOME extensions, applies keyboard shortcuts, sets Bengali fonts, removes Snap, and prepares a ready-to-use development and multimedia environment.


## Features

* Fully **automated setup** after a fresh Ubuntu installation.
* Removes **Snap** and installs the **Debian Firefox** version.
* Removes unwanted pre-installed apps.
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
├── setup.sh           # Main automation script
└── apps.sh            # Flatpak apps installation script
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
2. Place your `.deb` files in `ubuntu-setup/deb/` and the script will install them automatically. (Optional)

3. Make the script executable:

```bash
chmod +x ~/ubuntu-setup/setup.sh
```

4. Run the script:

```bash
~/ubuntu-setup/setup.sh
```

> The script uses `sudo` for package installation, system configuration, and Snap removal. You may be prompted for your password multiple times.

5. After completion, **reboot** the system to apply all GNOME settings and extensions.

### Install Flatpak Apps
Run `apps.sh` script:

```bash
~/ubuntu-setup/apps.sh
```

## Customizations

### GNOME Extensions

* User Themes
* Blur My Shell
* Fuzzy Search
* GS Connect
* App Indicator
* Caffein
* Add to Desktop
* ESC Overview
* Show Apps instead of Workspaces
* Status area horizontal spacing
* Drive menu
* Netspeed monitor
* Brightness control
* Just Perfection
* Rounded Corners
* Search Light
* Top bar organizer
* Clipboard indicator

### Keyboard Shortcuts

| Shortcut                  | Action                          |
| ------------------------- | ------------------------------- |
| Super + B                 | Browser                         |
| Super + C                 | VS Code                         |
| Super + E                 | File Explorer                   |
| Super + T                 | Terminal                        |
| Super + S                 | Settings                        |
| Super + R                 | Resource Monitor / Task Manager |
| Super + X                 | Extension Manager               |
| Super + N                 | Notepad / Text Editor           |
| Super + Q                 | Quit Program                    |
| Super + 1..4              | Switch to Workspace 1..4        |

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


## Utility Scripts

Any scripts placed in `ubuntu-setup/scripts/` will be copied to `usr/local/bin` and made executable, allowing you to run them as commands.

## Uninstall/Remove apps completely (deb/flatpak)
* To remove deb app completely, run the script from terminal:

```bash
sudo remove <package-name>         # Ex - firefox-esr
```

* To remove flatpak app completely:

```bash
sudo remove <package-id>           # Ex - org.mozilla.firefox
```

* To remove snap app completely:

```bash
sudo remove <package-name>         # Ex - firefox
```

## Terminal Profile
The posh terminal profile is installed from:

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

