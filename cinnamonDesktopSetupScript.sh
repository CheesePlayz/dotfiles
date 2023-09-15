#!/bin/bash

sudo apt update
sudo apt upgrade

# Install necessary software for script to work.
sudo apt install jq 


# Configuration
# 1. Startship installation from official website starship.rs

# Step 1. Install Starship
# Linux
echo "Installing starship..."
sudo curl -sS https://starship.rs/install.sh | sh
# Step 2. Set up your shell to use Starthip
# Bash
if ! grep -q 'eval "$(starship init bash)"' "$HOME/.bashrc"; then
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi
echo "Done."
# Step 3. Configure Starship
echo "Configuring starship.toml..."
sudo cat <<'EOF' > $HOME/.config/starship.toml
format = """
[](#33D17A)\
$os\
$username\
$hostname\
[](bg:#26A269 fg:#33D17A)\
$directory\
[](fg:#26A269 bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
\n[](fg:#33D17A) """

# Disable the blank line at the start of the prompt
# add_newline = false

# You can also replace your username with a neat symbol like   or disable this
# and use the os module below
[username]
show_always = true
style_user = "bg:#33D17A"
style_root = "bg:#33D17A"
format = '[$user ]($style)'
disabled = false

[hostname]
ssh_only = false
disabled = false
style = "bg:#33D17A"
format = '[@ $hostname ]($style)'

# An alternative to the username module which displays a symbol that
# represents the current operating system
[os]
style = "bg:#33D17A"
disabled = true # Disabled by default

[directory]
style = "bg:#26A269"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

# Here is how you can shorten some long paths by text replacement
# similar to mapped_locations in Oh My Posh:
#[directory.substitutions]
#"Documents" = "󰈙 "
#"Downloads" = " "
#"Music" = " "
#"Pictures" = " "
# Keep in mind that the order matters. For example:
# "Important Documents" = " 󰈙 "
# will not be replaced, because "Documents" was already substituted before.
# So either put "Important Documents" before "Documents" or use the substituted version:
# "Important 󰈙 " = " 󰈙 "

[c]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[docker_context]
symbol = " "
style = "bg:#06969A"
format = '[ $symbol $context ]($style) $path'

[elixir]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[elm]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[git_branch]
symbol = ""
style = "bg:#FCA17D"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#FCA17D"
format = '[$all_status$ahead_behind ]($style)'

[golang]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[gradle]
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[haskell]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[java]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[julia]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[nim]
symbol = "󰆥 "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[rust]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[scala]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
style = "bg:#33658A"
format = '[  $time ]($style)'
EOF
echo "Done."

# For the script to have these fonts and icons, Nerd Font is requierd

# 1.1. Download nerd font, JetBrainMono Nerd Font
# Name of the font is importan because of alacritty settings later on
# Latest version of font is v3.0.2, change if necessary
echo "Setting up fonts..."
zipDirectory="$HOME/Downloads"
nerdFontzip="JetBrainsMono.zip"
nerdFontFolder="JetBrainsMono"

# Make folder
sudo mkdir -p "/usr/share/fonts/truetype/$nerdFontFolder"

# 1.2. Unzip to specific folder
if [ -e "$zipDirectory/$nerdFontzip" ]; then
    echo "Zip is already in the directory. Not downloading..."
else
    sudo wget -P "$zipDirectory" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip

fi
# Extract
sudo rm -rf "/usr/share/fonts/truetype/$nerdFontFolder"/*
sudo unzip -d "/usr/share/fonts/truetype/$nerdFontFolder" "$zipDirectory/$nerdFontzip"


# 1.3. Reset font cache (-v for verbose)
sudo fc-cache -fv
echo "Done."


# 2. Alacritty

# 2.1. Add PPA repo to the apt 
sudo add-apt-repository ppa:aslatter/ppa -y

# 2.2 Install alacritty
sudo apt install alacritty


# 2.3 Set alacritty as default
# 2.3.1. Add alternatives to x-terminal-emulator
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 30

# 2.3.1. Remove gnome terminal from x-terminal-emulator
sudo update-alternatives --remove "x-terminal-emulator" /usr/bin/gnome-terminal.wrapper

# 2.4. Configure alacritty script
# 2.4.1. Add a new folder for alacritty
echo "Configuring alacritty.yml..."

mkdir "$HOME/.config/alacritty"

# 2.4.2. Add config file
cat <<EOF > $HOME/.config/alacritty/alacritty.yml
window:
  dynamic_title: true
  startup_mode: Windowed
  dimensions:
    columns: 120
    lines: 26
  opacity: 0.9

cursor:
  style:
    shape: Block       # Supported => ▇ Block, _ Underline, | Beam
    blinking: Always          # Supported => Never, off, on, Always

selection:
  save_to_clipboard: true

font:
  size: 10
  offset:
    x: 0
    y: 0
  normal:
    family: JetBrainsMono Nerd Font
    style: Regular
  bold:
    family: JetBrainsMono Nerd Font
    style: Bold
  italic:
    family: JetBrainsMono Nerd Font
    style: Regular Italic
  bold_italic:
    family: JetBrainsMono Nerd Font
    style: Bold Italic

schemes:

  darcula: &darcula
    primary:
      background: '#414141'
      foreground: '#f8f8f2'
    normal:
      black:   '#000000'
      red:     '#ff5555'
      green:   '#50fa7b'
      yellow:  '#f1fa8c'
      blue:    '#caa9fa'
      magenta: '#ff79c6'
      cyan:    '#8be9fd'
      white:   '#bfbfbf'
    bright:
      black:   '#282a35'
      red:     '#ff6e67'
      green:   '#5af78e'
      yellow:  '#f4f99d'
      blue:    '#caa9fa'
      magenta: '#ff92d0'
      cyan:    '#9aedfe'
      white:   '#e6e6e6'

colors: *darcula

EOF
echo "Done."
# 3. Setting up cinnamon desktop

# 3.1 Cinnamon interface
echo "Configuring Cinnamon interface..."
gsettings set org.cinnamon.desktop.interface automatic-mnemonics true
gsettings set org.cinnamon.desktop.interface buttons-have-icons false
gsettings set org.cinnamon.desktop.interface can-change-accels false
gsettings set org.cinnamon.desktop.interface clock-show-date false
gsettings set org.cinnamon.desktop.interface clock-show-seconds false
gsettings set org.cinnamon.desktop.interface clock-use-24h true
gsettings set org.cinnamon.desktop.interface cursor-blink true
gsettings set org.cinnamon.desktop.interface cursor-blink-time 1200
gsettings set org.cinnamon.desktop.interface cursor-blink-timeout 10
gsettings set org.cinnamon.desktop.interface cursor-size 24
gsettings set org.cinnamon.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.cinnamon.desktop.interface enable-animations true
gsettings set org.cinnamon.desktop.interface first-day-of-week 7
gsettings set org.cinnamon.desktop.interface font-name 'Ubuntu 10'
gsettings set org.cinnamon.desktop.interface gtk-color-palette 'black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90'
gsettings set org.cinnamon.desktop.interface gtk-color-scheme ''
gsettings set org.cinnamon.desktop.interface gtk-enable-primary-paste true
gsettings set org.cinnamon.desktop.interface gtk-im-module ''
gsettings set org.cinnamon.desktop.interface gtk-im-preedit-style 'callback'
gsettings set org.cinnamon.desktop.interface gtk-im-status-style 'callback'
gsettings set org.cinnamon.desktop.interface gtk-key-theme 'Default'
gsettings set org.cinnamon.desktop.interface gtk-overlay-scrollbars true
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark'
gsettings set org.cinnamon.desktop.interface gtk-theme-backup 'Adwaita'
gsettings set org.cinnamon.desktop.interface gtk-timeout-initial 200
gsettings set org.cinnamon.desktop.interface gtk-timeout-repeat 20
gsettings set org.cinnamon.desktop.interface high-contrast false
gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y'
gsettings set org.cinnamon.desktop.interface icon-theme-backup 'gnome'
gsettings set org.cinnamon.desktop.interface keyboard-layout-prefer-variant-names false
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper false
gsettings set org.cinnamon.desktop.interface menubar-accel 'F10'
gsettings set org.cinnamon.desktop.interface menubar-detachable false
gsettings set org.cinnamon.desktop.interface menus-have-icons true
gsettings set org.cinnamon.desktop.interface menus-have-tearoff false
#gsettings set org.cinnamon.desktop.interface scaling-factor uint32 0
gsettings set org.cinnamon.desktop.interface show-input-method-menu true
gsettings set org.cinnamon.desktop.interface show-unicode-menu true
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.0
gsettings set org.cinnamon.desktop.interface toolbar-detachable false
gsettings set org.cinnamon.desktop.interface toolbar-icons-size 'large'
gsettings set org.cinnamon.desktop.interface toolbar-style 'both-horiz'
gsettings set org.cinnamon.desktop.interface toolkit-accessibility false
gsettings set org.cinnamon.desktop.interface upscale-fractional-scaling false
echo "Done."

# 3.2. Desktop and window effects
echo "Configuring desktop and window effects..."
gsettings set org.cinnamon desktop-effects true
gsettings set org.cinnamon desktop-effects-change-size true
gsettings set org.cinnamon desktop-effects-close 'traditional'
gsettings set org.cinnamon desktop-effects-map 'move'
gsettings set org.cinnamon desktop-effects-minimize 'fade'
gsettings set org.cinnamon desktop-effects-on-dialogs true
gsettings set org.cinnamon desktop-effects-on-menus true
gsettings set org.cinnamon desktop-effects-sizechange-effect 'scale'
gsettings set org.cinnamon desktop-effects-sizechange-time 100
gsettings set org.cinnamon desktop-effects-sizechange-transition 'easeInQuad'
gsettings set org.cinnamon desktop-effects-workspace true
# 3.2.1 theme
gsettings set org.cinnamon.theme gtk-version-scrollbar-multiplier 1.5
gsettings set org.cinnamon.theme name 'Mint-Y-Dark'
gsettings set org.cinnamon.theme symbolic-relative-size 0.67000000000000004
gsettings set org.cinnamon.theme theme-cache-updated 0
echo "Done."
# 3.3. Keyboard and keyboard shortcuts

# 3.3.1. Add new locale to locale.gen
# Assuming the US or ENG keyboard is set on installation
echo "Removing(#) commented locale.gen languages..."
sudo sed -i '/^# hr_HR.UTF-8 UTF-8/s/^# //' /etc/locale.gen
sudo sed -i '/^# en_EN.UTF-8 UTF-8/s/^# //' /etc/locale.gen
echo "Done."

# 3.3.2. Set up keyboard layouts, this needs to be persistent
echo "Setting up keyboard layouts..."
if ! grep -q "setxkbmap us,hr" "$HOME/.profile"; then
   echo "setxkbmap us,hr" >> "$HOME/.profile"
fi
echo "Done."

# 3.3.3. Add custom keyboard shortcuts
echo "Adding custom shortcuts..."

# define customs
gsettings set org.cinnamon.desktop.keybindings custom-list "['custom0', 'custom1']"

# 3.3.3.1. custom0/ - wmCtrl Close Active Window
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name 'wmctrl Close Active Window'
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Shift><Alt>Q']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command 'wmctrl -c :ACTIVE:'
#dconf write /org/cinnamon/desktop/keybindings/custom-list/custom0/ binding "['<Shift><Alt>Q']"

# 3.3.3.2. custom1/ - Launch Alacritty Terminal
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ name 'Launch Alacritty Terminal'
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ binding "['<Shift><Alt><Return>']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/ command 'alacritty'
#dconf write /org/cinnamon/desktop/keybindings/custom-list/custom1/ binding "['<Shift><Alt>Return']"

echo "Done."

# 3.4 Install software and set desktop items

# Installing custom software from official repos

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt update && sudo apt install codium

sudo apt install codium 
sudo apt install sublime-text 
sudo apt install steam 
sudo apt install blender

# Installing from flatpak

sudo flatpak install flathub com.discordapp.Discord
sudo flatpak install flathub com.google.AndroidStudio

# Panel settings
echo "Setting up panel grouped items..."
replace_applets() {
    local config_file="$HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json"
    local configDirectory="$HOME/.config/cinnamon/spices/grouped-window-list@cinnamon.org"

    if [ -f "$config_file" ]; then
        jq '.["pinned-apps"]["value"] = ["nemo.desktop", "firefox.desktop", "com.alacritty.Alacritty.desktop", "com.discordapp.Discord.desktop:flatpak", "codium.desktop", "blender.desktop", "com.google.AndroidStudio.desktop:flatpak", "sublime_text.desktop", "steam.desktop"]' "$config_file" > $configDirectory/replacement.json
        mv "$configDirectory/replacement.json" "$configDirectory/2.json" 
    else
        echo "Configuration file not found: $config_file"
    fi
}

replace_applets

echo "Done."
echo "The script finished its job. Please reboot."