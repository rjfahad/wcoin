#!/bin/bash

# Update and upgrade the package manager
pkg update && pkg upgrade -y

# Install the required packages
pkg install python rust git -y

# Check if the 'wcoin' directory already exists
if [ -d "wcoin" ]; then
    echo "'wcoin' directory already exists. Skipping cloning..."
    cd wcoin || exit
else
    # Clone the wcoin repository if it doesn't exist
    git clone https://github.com/elphador/wcoin.git
    cd wcoin || exit
fi

# Install Python dependencies from the requirements.txt file
pip install -r requirements.txt

# Check if there is an error in the pip installation
if [ $? -ne 0 ]; then
    echo "Error in pip installation. Attempting to fix..."

    # Ensure pip is installed and up-to-date
    python -m ensurepip --upgrade || python -m ensurepip
    python -m pip install --upgrade pip

    # Install pyfiglet and other dependencies
    python -m pip install pyfiglet
    python -m pip install -r requirements.txt
fi

# Run the wcoin.py script after successful installation
echo "Starting wcoin.py..."
python3 wcoin.py
