#!/bin/bash

# Define color codes for a vibrant touch
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to install necessary packages
install_packages() {
    echo -e "${BLUE}Updating and upgrading your system...${NC}"
    pkg update && pkg upgrade -y

    echo -e "${GREEN}Installing essential packages: git, nano, and curl...${NC}"
    pkg install git nano curl bash -y

    echo -e "${GREEN}Installing development tools: clang, cmake, ninja, rust, and make...${NC}"
    pkg install clang cmake ninja rust make -y

    echo -e "${GREEN}Installing Python 3.10...${NC}"
    pkg install python3.10 -y
}

# Clone the WCoin repository and prepare the environment
setup_bot() {
    if [ ! -d "WCoinBot" ]; then
        echo -e "${BLUE}Cloning the WCoin repository...${NC}"
        git clone https://github.com/rjfahad/wcoin.git || { echo -e "${RED}Failed to clone the repository!${NC}"; exit 1; }

        cd wcoin || { echo -e "${RED}Failed to enter WCoin directory!${NC}"; exit 1; }

        echo -e "${BLUE}Copying environment settings...${NC}"
        cp .env-example .env

        echo -e "${YELLOW}Opening .env for customization...${NC}"
        nano .env
    else
        echo -e "${GREEN}WCoinBot is already installed! Navigating to the directory...${NC}"
        cd wcoin || { echo -e "${RED}Error navigating to WCoin directory.${NC}"; exit 1; }
    fi
}

# Setup Python virtual environment and install dependencies
setup_python_env() {
    if [ ! -d "venv" ]; then
        echo -e "${BLUE}Creating a Python virtual environment...${NC}"
        python3.10 -m venv venv || { echo -e "${RED}Failed to create virtual environment!${NC}"; exit 1; }

        echo -e "${BLUE}Activating the virtual environment...${NC}"
        source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment!${NC}"; exit 1; }

        echo -e "${BLUE}Installing dependencies...${NC}"
        pip3.10 install --upgrade pip wheel || { echo -e "${RED}Failed to install pip and wheel!${NC}"; exit 1; }
        pip3.10 install -r requirements.txt || { echo -e "${RED}Failed to install dependencies from requirements.txt!${NC}"; exit 1; }
    else
        echo -e "${BLUE}Activating the existing virtual environment...${NC}"
        source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment!${NC}"; exit 1; }
    fi
}

# Run the bot
run_bot() {
    echo -e "${GREEN}Starting WCoinBot...${NC}"
    python3.10 main.py || { echo -e "${RED}Failed to run the bot!${NC}"; exit 1; }
}

# The main function where all magic happens
main() {
    install_packages
    setup_bot
    setup_python_env
    run_bot
}

# Call the main function to start the adventure
main
