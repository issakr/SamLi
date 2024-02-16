# SamLi

## Description

SamLi is a command-line interface (CLI) tool designed to streamline development and deployment tasks related to AWS Serverless Application Model (SAM) applications. With SamLi, developers can quickly create, test, and deploy serverless applications on AWS, reducing the time and complexity of the deployment process.

Key features of SamLi include:

- Local Testing: Easily test Lambda functions and API Gateway endpoints locally before deploying to AWS.
- Simplified Deployment: Streamline the deployment process by automating common tasks such as packaging and uploading artifacts to AWS.
- CLI Commands: Intuitive CLI commands provide a user-friendly interface for managing SAM applications, including testing, updating, and uninstalling.

Whether you're a beginner getting started with serverless development or an experienced AWS developer looking to streamline your workflow, SamLi offers a convenient and efficient solution for managing SAM applications.

## Installation

You can install the project using `curl` by running the following command in your terminal:

```bash
curl -sSL "https://raw.githubusercontent.com/issakr/SamLi/master/install.sh" | bash
```

This command will automatically download and execute the installation script, setting up the project on your system.

Alternatively, you can clone the repository and run the installation script manually:

```bash
git clone https://github.com/issakr/SamLi.git
cd SamLi
./install.sh
```

Make sure you have appropriate permissions and that you trust the source before executing scripts downloaded from the internet.

## Usage

Describe how to use your project, including any command-line options and examples of typical usage scenarios.

```bash
# Example usage
samli test myHandler --env dev  -e event.json
```

## Commands

- test: Locally test a given handler
- uninstall: Uninstall the CLI tool
- update: Update the CLI tool to the latest version
- generate-event: Generate an AppSync event with appToken
