#!/bin/bash

SILENT=false

# Define constants for your CLI
CLI_NAME="samli"

# script_pwd=$(pwd)/bin
SAMLI_HOME_DIR="$HOME/$CLI_NAME" # or any other preferred installation directory

debug() {
    if [ ! -n $SILENT ]; then
        echo "$1"
    fi
}
check_cli() {
    # Check if the CLI executable already exists in $PATH
    if command -v "$CLI_NAME" >/dev/null 2>&1; then
        echo "The $CLI_NAME CLI is already installed."
        exit 0
    fi
}
# Function to display installation progress
install_progress() {
    debug -e "\n[INFO] $1"
}

# Function to check if AWS SAM is installed
check_sam() {
    if command -v sam &>/dev/null; then
        debug "AWS SAM is installed."
    else
        echo "AWS SAM is not installed. Please install it before continuing."
        echo $'You can install AWS SAM by following the instructions at:\n\thttps://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html'
        exit 1
    fi
}

# Function to check if Docker is installed
check_docker() {
    if command -v docker &>/dev/null; then
        debug "Docker is installed."
    else
        echo "Docker is not installed. Please install Docker before continuing."
        echo $'You can install Docker by following the instructions at:\n\thttps://docs.docker.com/get-docker/'
        exit 1
    fi
}

addLineToFile() {
    local line=$1
    local file=$2
    if ! grep -qF "$line" "$file"; then
        echo "export SAMLI_HOME_DIR=\"$SAMLI_HOME_DIR\"" >>"$file"
        echo "$line" >>"$file"
        debug "'$file' updated"
    else
        debug "Line already exists in '$file'"
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
    add_to_bashrc

    export PATH="$SAMLI_HOME_DIR/bin:$PATH"
}

if [[ -n $1 ]]; then
    tag=$1
else
    # https://github.com/issakr/SamLi/blob/v0.0.3/bin/VERSION
    tag=$(curl -sSL "https://raw.githubusercontent.com/issakr/SamLi/master/bin/VERSION")
fi

# Function to install the CLI
install() {
    echo "Installing $CLI_NAME v$tag..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$SAMLI_HOME_DIR"

    # # Download the CLI executable using curl and install it
    (curl -sSL "https://github.com/issakr/SamLi/archive/refs/tags/v$tag.zip" -o $CLI_NAME.zip &&
        unzip -q $CLI_NAME.zip -d .) &&
        (cp -r $CLI_NAME-$tag/bin $SAMLI_HOME_DIR &&
            addToSHELL &&
            rm -rf $CLI_NAME.zip $CLI_NAME-$tag)
}

# Function to display a progress bar
# Usage: progress_bar <current_progress> <total_progress>
progress_bar() {
    local current=$1
    local total=$2
    local maxlen=50 # Maximum length of the progress bar
    local progress=$((current * maxlen / total))
    local remaining=$((maxlen - progress))

    printf "["
    printf "%${progress}s" | tr ' ' '='
    printf "%${remaining}s" | tr ' ' '.'
    printf "] %d%%" $((current * 100 / total))
}

STEPS=("check_cli" "check_sam" "check_docker" "install")
# Example: Number of steps

# Main script logic
while [[ $# -gt 0 ]]; do
    case $1 in
    -s | --silent)
        SILENT=true
        ;;
    # -h | --help)
    #     cli_help
    #     ;;
    # -* | --*)
    #     echo "Unknown option $1"
    #     cli_help
    #     ;;
    esac
done

total_steps=${#STEPS[@]}
for ((i = 0; i < total_steps; i++)); do
    ${STEPS[i]} # Call the function for the current step
    progress_bar $((i + 1)) $total_steps
    printf "\r" # Move cursor back to the beginning of the line
done

echo "" # Move to the next line after the progress bar is complete
echo "$CLI_NAME v$tag successfully installed ✅"
