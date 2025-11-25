#!/bin/bash

pacman_packages=(
    stow
    xdg-desktop-portal-gtk
    thunar
    alacritty
    zsh
    power-profiles-daemon-openrc
    waybar
    gnome-disk-utility
    brightnessctl
    flatpak
    gvfs
    swaybg 
    gvfs-mtp
    xdg-user-dirs
    network-manager-applet
    blueman
    bluez-utils
    bluez-openrc
    eza
    bluez
    qt6-svg 
    qt6-declarative
    ttf-font-awesome
    qt5ct
    qt6ct
    grim
    slurp
    udiskie
    kvantum
    kvantum-qt5 
    hypridle
    hyprlock
    pamixer
    playerctl
    papirus-icon-theme
    pavucontrol
    gnome-keyring
    swaync
    rofi-wayland
    fastfetch
    starship
)

yay_packages=(
    wlogout
    waybar-module-pacman-updates-git
    pyprland
    xfce-polkit
    waypaper-git
    hyprshot-git
)

echo "Installing all pacman packages..."
sudo pacman -S --noconfirm "${pacman_packages[@]}"

echo "Installing all yay packages..."
yay -S --noconfirm --removemake "${yay_packages[@]}"

echo "All packages have been installed."

mkdir -p ~/.local
mkdir -p ~/.local/share

echo "Syncing dotfiles with stow..."
stow .

echo "Starting services..."
# Add and start power-profiles-daemon
sudo rc-update add power-profiles-daemon default
sudo rc-service power-profiles-daemon start
# Add and start bluetooth
sudo rc-update add bluetooth default
sudo rc-service bluetooth start
# Add and start SDDM
sudo rc-update add sddm default

# Update the user directories
echo "Updating user directories..."
xdg-user-dirs-update

mkdir -p ~/.config/gtk-4.0
#ln -s  ~/.local/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/assets ~/.config/gtk-4.0
#ln -s ~/.local/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
#ln -s ~/.local/share/themes/catppuccin-mocha-blue-standard+default/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

sudo flatpak override --filesystem=~/.themes
sudo flatpak override --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum
flatpak install org.kde.KStyle.Kvantum/x86_64/5.15-22.08 org.kde.KStyle.Kvantum/x86_64/5.15-23.08 org.kde.KStyle.Kvantum/x86_64/6.5 org.kde.KStyle.Kvantum/x86_64/6.6 org.kde.KStyle.Kvantum/x86_64/5.15 org.kde.KStyle.Kvantum/x86_64/5.15-21.08

sudo touch /etc/sddm.conf 

echo "Creating a backup of the SDDM configuration file..."
sudo cp /etc/sddm.conf /etc/sddm.conf.bak

# Set up SDDM theme
echo "Setting up sddm theme..."
sudo cp -r  ~/dotfiles/sddm/catppuccin-mocha/ /usr/share/sddm/themes/
sudo sed -i.bak '/\[Theme\]/,/^\[/s/.*//g' /etc/sddm.conf && echo -e "[Theme]\nCurrent=catppuccin-macchiato" | sudo tee -a /etc/sddm.conf
