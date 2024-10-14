#!/bin/bash

# Define color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to install required packages
install_packages() {
    echo -e "${BLUE}Updating and upgrading packages...${NC}"
    pkg update && pkg upgrade -y

    echo -e "${GREEN}Installing git and nano...${NC}"
    pkg install git nano -y

    echo -e "${GREEN}Installing development tools: clang, cmake, ninja, rust, make...${NC}"
    pkg install clang cmake ninja rust make -y

    echo -e "${GREEN}Installing tur-repo...${NC}"
    pkg install tur-repo -y

    echo -e "${GREEN}Installing Python 3.10...${NC}"
    pkg install python3.10 -y
}

# Check if WCoinBot directory exists
if [ ! -d "WCoinBot" ]; then
    # Install packages if the directory does not exist
    install_packages

    # Upgrade pip and install wheel
    echo -e "${BLUE}Upgrading pip and installing wheel...${NC}"
    pip3.10 install --upgrade pip wheel --quiet

    # Clone the WCoinBot repository
    echo -e "${BLUE}Cloning WCoinBot repository...${NC}"
    git clone https://github.com/rjfahad/wcoin.git || { echo -e "${RED}Failed to clone repository! Check the URL or your connection.${NC}"; exit 1; }

    # Change directory to WCoinBot
    echo -e "${BLUE}Navigating to WCoinBot directory...${NC}"
    cd wcoin || { echo -e "${RED}Failed to navigate to WCoinBot directory!${NC}"; exit 1; }

 

else
    # If the directory exists, navigate to it
    echo -e "${GREEN}WCoinBot is already installed. Navigating to the directory...${NC}"
    cd wcoin || { echo -e "${RED}Failed to navigate to WCoinBot directory!${NC}"; exit 1; }
fi

# Check if the Python virtual environment exists
if [ ! -d "venv" ]; then
    # Set up Python virtual environment
    echo -e "${BLUE}Setting up Python virtual environment...${NC}"
    python3.10 -m venv venv || { echo -e "${RED}Failed to create virtual environment!${NC}"; exit 1; }

    # Activate the virtual environment
    echo -e "${BLUE}Activating Python virtual environment...${NC}"
    source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment!${NC}"; exit 1; }

    # Install required Python packages
    echo -e "${BLUE}Installing Python dependencies from requirements.txt...${NC}"
    pip3.10 install -r requirements.txt --quiet || { echo -e "${RED}Failed to install dependencies!${NC}"; exit 1; }

else
    # If the virtual environment exists, activate it
    echo -e "${BLUE}Activating Python virtual environment...${NC}"
    source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment!${NC}"; exit 1; }

    echo -e "${GREEN}Virtual environment already exists. Skipping dependency installation.${NC}"
fi

# Run the bot
echo -e "${GREEN}Running the bot...${NC}"
python3.10 main.py || { echo -e "${RED}Failed to run the bot!${NC}"; exit 1; }

echo -e "${GREEN}Script execution completed!${NC}"
