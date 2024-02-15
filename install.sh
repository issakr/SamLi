#!/bin/bash

# Define constants for your CLI
CLI_NAME="samLI"
CLI_EXECUTABLE="samli"

# The root directory of your CLI
CLI_ROOT="$(cd "$(dirname "$0")" && pwd)"

# script_pwd=$(pwd)/bin
INSTALL_DIR="$HOME/$CLI_EXECUTABLE" # or any other preferred installation directory

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

# Function to check if the CLI is already installed
check_installed() {
    if [ -d "$INSTALL_DIR" ] || command -v "$CLI_EXECUTABLE" >/dev/null 2>&1; then
        install_progress "$CLI_NAME is already installed on this machine."
        exit 0
    fi
}

showPATH() {
    oldifs="$IFS" #store old internal field separator
    IFS=:         #specify a new internal field separator
    for DIR in $PATH; do echo $DIR; done
    IFS="$oldifs" #restore old internal field separator
}

addToSHELL() {
    echo "Adding $CLI_EXECUTABLE to bash commands"

    # Function to add INSTALL_DIR/bin to PATH in bash configuration file
    add_to_bashrc() {
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >>~/.bashrc
    }

    # Function to add INSTALL_DIR/bin to PATH in zsh configuration file
    add_to_zshrc() {

        # Function to add INSTALL_DIR/bin to PATH in .zshenv file
        add_to_zshenv() {
            echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >>~/.zshenv

        }
        # Function to add INSTALL_DIR/bin to PATH in .zshrc file
        add_to_zshrc() {
            echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >>~/.zshrc

        }
        # Check if .zshenv exists and update it, otherwise update .zshrc
        if [ -f ~/.zshenv ]; then
            add_to_zshenv
        else
            add_to_zshrc
        fi
    }

    add_to_zshrc
    add_to_bashrc

    export PATH="$INSTALL_DIR/bin:$PATH"
}

# Function to install the CLI
install() {
    local tag=$(curl -sSL "https://raw.githubusercontent.com/issakr/SamLi/master/bin/VERSION")
    echo "Installing $CLI_NAME v$tag..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"

    # # Download the CLI executable using curl and install it
    curl -sSL "https://github.com/issakr/SamLi/archive/refs/tags/v$tag.zip" -o $CLI_EXECUTABLE.zip &&
        unzip -q $CLI_EXECUTABLE.zip -d .

    cp -r $CLI_EXECUTABLE-$tag/bin $INSTALL_DIR
    rm -rf $CLI_EXECUTABLE.zip $CLI_EXECUTABLE-$tag

    addToSHELL
    ls -la $INSTALL_DIR/bin/
    # Ensure the executable has the correct permissions
    chmod +x "$INSTALL_DIR/bin/$CLI_EXECUTABLE"

    echo "Install complete"
    echo "Installed $CLI_NAME v$tag to $INSTALL_DIR"
}

# Main script logic
# check_installed
# check_sam
# check_docker

install
