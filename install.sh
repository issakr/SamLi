#!/bin/bash
# This script installs the CLI tool

# Define constants for the CLI
CLI_NAME="samLI"
CLI_EXECUTABLE="samli"

source $CLI_WORKDIR/lib/common
check_for_new_release

# Define the installation directory
SAMLI_HOME_DIR="$HOME/$CLI_EXECUTABLE" # or any other preferred installation directory

# Function to check if the CLI is already installed
check_timefonds() {
    # Check if the CLI executable already exists in $PATH
    if command -v "$CLI_EXECUTABLE" >/dev/null 2>&1; then
        echo "The $CLI_NAME CLI is already installed."
        exit 0
    fi
}

# Function to display installation progress
install_progress() {
    echo -e "\n[INFO] $1"
}

# Function to check if AWS SAM is installed
check_sam() {
    if command -v sam &>/dev/null; then
        echo "AWS SAM is installed."
    else
        echo "AWS SAM is not installed. Please install it before continuing."
        echo $'You can install AWS SAM by following the instructions at:\n\thttps://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html'
        exit 1
    fi
}

# Function to check if Docker is installed
check_docker() {
    if command -v docker &>/dev/null; then
        echo "Docker is installed."
    else
        echo "Docker is not installed. Please install Docker before continuing."
        echo $'You can install Docker by following the instructions at:\n\thttps://docs.docker.com/get-docker/'
        exit 1
    fi
}

# Function to add CLI executable to the user's shell
addToSHELL() {
    debug "Adding $CLI_EXECUTABLE to Shell"
    line='export PATH=$PATH:$SAMLI_HOME_DIR/bin'

    # Function to add SAMLI_HOME_DIR/bin to PATH in bash configuration file
    add_to_bashrc() {
        if ! grep -qF "$line" ~/.bashrc; then
            echo "export SAMLI_HOME_DIR=\"$SAMLI_HOME_DIR\"" >>~/.bashrc
            echo "$line" >>~/.bashrc
            debug "Line added to ~/.bashrc"
        else
            echo "Line already exists in ~/.bashrc"
        fi
    }

    # Function to add SAMLI_HOME_DIR/bin to PATH in zsh configuration file
    add_to_zshrc() {
        # Function to add SAMLI_HOME_DIR/bin to PATH in .zshenv file
        add_to_zshenv() {
            if ! grep -qF "$line" ~/.zshenv; then
                echo "export SAMLI_HOME_DIR=\"$SAMLI_HOME_DIR\"" >>~/.zshenv
                echo "$line" >>~/.zshenv
                debug "Line added to ~/.zshenv"
            else
                echo "Line already exists in ~/.zshenv"
            fi
        }

        # Function to add SAMLI_HOME_DIR/bin to PATH in .zshrc file
        add_to_zshrc() {
            if ! grep -qF "$line" ~/.zshrc; then
                echo "export SAMLI_HOME_DIR=\"$SAMLI_HOME_DIR\"" >>~/.zshrc
                echo "$line" >>~/.zshrc
                debug "Line added to ~/.zshrc"
            else
                echo "Line already exists in ~/.zshrc"
            fi
        }

        # Check if .zshenv exists and update it, otherwise update .zshrc
        if [ -f ~/.zshenv ]; then
            add_to_zshenv
        else
            add_to_zshrc
        fi
    }

    add_to_zshrc
    # add_to_bashrc

    export PATH="$SAMLI_HOME_DIR/bin:$PATH"
}

# Function to install the CLI
install() {
    echo "Installing $CLI_NAME v$tag..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$SAMLI_HOME_DIR"

    # Download the CLI executable using curl and install it
    (curl -sSL "https://github.com/issakr/SamLi/archive/refs/tags/v$tag.zip" -o $CLI_EXECUTABLE.zip &&
        unzip -q $CLI_EXECUTABLE.zip -d . &&
        cp -r $CLI_EXECUTABLE-$tag/bin $SAMLI_HOME_DIR &&
        addToSHELL &&
        rm -rf $CLI_EXECUTABLE.zip $CLI_EXECUTABLE-$tag) &&
        echo "Installed $CLI_NAME v$tag to $SAMLI_HOME_DIR complete ✅" ||
        echo "Installation failed ! 🛑"
}

# Main script logic
install
