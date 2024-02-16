#!/bin/bash

# Define constants for your CLI
CLI_NAME="samLI"
CLI_EXECUTABLE="samli"

source "./bin/lib/common"
check_for_new_release

# script_pwd=$(pwd)/bin
SAMLI_HOME_DIR="$HOME/$CLI_EXECUTABLE" # or any other preferred installation directory

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

addToSHELL() {
    line='export PATH=$PATH:$SAMLI_HOME_DIR/bin'

    # Function to add SAMLI_HOME_DIR/bin to PATH in bash configuration file
    add_to_bashrc() {
        addLineToFile "$line" ~/.bashrc

    }

    # Function to add SAMLI_HOME_DIR/bin to PATH in zsh configuration file
    add_to_zshrc() {

        # Function to add SAMLI_HOME_DIR/bin to PATH in .zshenv file
        add_to_zshenv() {
            addLineToFile "$line" ~/.zshenv
        }
        # Function to add SAMLI_HOME_DIR/bin to PATH in .zshrc file
        add_to_zshrc() {
            addLineToFile "$line" ~/.zshrc
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

if [[ -n $1 ]]; then
    tag=$1
else
    tag=$(curl -sSL "https://raw.githubusercontent.com/issakr/SamLi/master/bin/VERSION")
fi

# Function to install the CLI
install() {
    echo "Installing $CLI_NAME v$tag..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$SAMLI_HOME_DIR"

    # # Download the CLI executable using curl and install it
    (curl -sSL "https://github.com/issakr/SamLi/archive/refs/tags/v$tag.zip" -o $CLI_EXECUTABLE.zip &&
        unzip -q $CLI_EXECUTABLE.zip -d . &&
        cp -r $CLI_EXECUTABLE-$tag/bin $SAMLI_HOME_DIR &&
        addToSHELL &&
        rm -rf $CLI_EXECUTABLE.zip $CLI_EXECUTABLE-$tag) &&
        echo "Installed $CLI_NAME v$tag to $SAMLI_HOME_DIR complete ✅" ||
        echo "Instalation failed ! 🛑"
}

# Main script logic
# check_installed
# check_sam
# check_docker

install
