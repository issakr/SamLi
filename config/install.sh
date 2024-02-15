#!/bin/bash

# Define constants for your CLI
CLI_NAME="timefondsCLI"
CLI_EXECUTABLE="timefonds"
CLI_ROOT="$(cd "$(dirname "$0")" && pwd)" # The root directory of your CLI

# script_pwd=$(pwd)/bin
INSTALL_DIR="$HOME/bin/timefonds" # or any other preferred installation directory

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

# Function to install the CLI
install() {
    echo "Installing $CLI_NAME..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"

    # Download the CLI executable using curl and install it
    # curl -sSL "$1" | tar -xz -C "$INSTALL_DIR" "$CLI_NAME"

    #     mkdir -p $HOME/bin/timefonds && cd $HOME/bin/timefonds
    #     echo "Installing $CLI_NAME"
    #     mkdir lib
    #     cp -r $script_pwd/lib/* ./lib
    #     cp -r $script_pwd/commands/* ./commands
    #     cp $script_pwd/timefonds-cli .

    #     echo "Adding $CLI_EXECUTABLE to bash commands"
    #     current_profile=""
    #     if [ ! -e "${HOME}/.bash_profile" ]; then
    #         touch $HOME/.bash_profile
    #         current_profile=$(cat $HOME/.profile)
    #     else
    #         current_profile=$(sed '/export PATH/d' $HOME/.bash_profile)
    #     fi
    #     printf '%s\n' "export PATH=${HOME}/bin/$CLI_EXECUTABLE:${PATH}" \
    #         "$current_profile" >$HOME/.bash_profile
    #     echo "Install complete"

    # Ensure the executable has the correct permissions
    # chmod +x "$INSTALL_DIR/$CLI_NAME"

    echo "Installed $CLI_NAME to $INSTALL_DIR"
}

# Main script logic
# check_installed
# check_sam
# check_docker
install
