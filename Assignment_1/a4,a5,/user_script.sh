#!/bin/bash

# Create a new group
sudo groupadd devops

# Create a new user and assign to group

sudo useradd -m -g devops devuser

# Set a password (manually interactive if executed)

# sudo passwd devuser

# Add user to another group (e.g., sudo)

sudo usermod -aG sudo devuser

# Create a test file and change ownership

touch devfile.txt
sudo chown devuser:devops devfile.txt
sudo chmod 740 devfile.txt

# Show permissions

ls -l devfile.txt

# Optional cleanup (comment out if not needed)
# sudo userdel -r devuser
# sudo groupdel devops
