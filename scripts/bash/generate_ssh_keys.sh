#!/bin/bash

# Path to your control node's SSH key
KEY_PATH="$HOME/.ssh/control_node_homeserver"

if [ ! -f "$KEY_PATH" ]; then
  echo "Key not found, generating a new SSH key pair..."
  ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
  echo "SSH key pair generated successfully!"
else
  echo "SSH key already exists at $KEY_PATH. Using the existing key."
fi
