#!/bin/bash

# Function to install Xcode Command Line Tools
install_xcode_cli_tools() {
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install 2>&1 | grep installed || true
}

# Function to install Homebrew
install_homebrew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Function to install Neovim
install_neovim() {
    echo "Installing Neovim..."
    if command -v nvim >/dev/null 2>&1; then
        echo "Neovim is already installed."
    else
        brew install neovim
    fi
}

# Function to apply BlazeNvim configuration
apply_config() {
    echo "Applying BlazeNvim configuration..."
    CONFIG_DIR="${HOME}/.config/nvim"
    BACKUP_DIR="${HOME}/.config/nvim_backup_$(date +%s)"

    # Backup existing config if it exists
    if [ -d "$CONFIG_DIR" ]; then
        echo "Backing up existing Neovim config to $BACKUP_DIR"
        mv "$CONFIG_DIR" "$BACKUP_DIR"
    fi

    # Clone the BlazeNvim config repository
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/BlazeNvim/config.git "$TEMP_DIR"
    
    # Copy the Neovim config to the correct location
    cp -r "$TEMP_DIR/nvim" "$CONFIG_DIR"

    # Clean up
    rm -rf "$TEMP_DIR"

    echo "BlazeNvim configuration applied successfully."
}

# Main script execution
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        install_xcode_cli_tools
        install_homebrew
    fi
    install_neovim    apply_config
    echo "BlazeNvim installation completed ✅."
else
    echo "Installation Failed: Unsupported OS. This script only supports macOS."
    exit 1
fi
