#!/bin/bash

# Prompt for IP address and gateway
read -p "Enter the static IP address (e.g., 192.168.68.71/24): " STATIC_IP
read -p "Enter the gateway IP address (e.g., 192.168.68.1): " GATEWAY

# Extract the base IP address (without /24) for the hosts file
BASE_IP=$(echo "$STATIC_IP" | cut -d'/' -f1)

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# Install rpi-connect-lite and start rpi-connect
echo "Installing rpi-connect-lite..."
sudo apt install -y rpi-connect-lite
echo "Starting rpi-connect service..."
sudo rpi-connect on

# Add Proxmox repository and GPG key
echo "Adding Proxmox repository and GPG key..."
curl -s http://global.mirrors.apqa.cn/proxmox/debian/pveport.gpg -o /etc/apt/trusted.gpg.d/pveport.gpg
echo "deb [arch=arm64] http://global.mirrors.apqa.cn/proxmox/debian/pve bookworm port" | sudo tee -a /etc/apt/sources.list

# Update package lists and upgrade system
echo "Updating package lists and upgrading system..."
sudo apt update
sudo apt dist-upgrade -y

# Configure network interfaces
echo "Configuring network interfaces..."
cat <<EOF | sudo tee /etc/network/interfaces
auto lo
iface lo inet loopback

iface eth0 inet manual

auto vmbr0
iface vmbr0 inet static
        address $STATIC_IP
        gateway $GATEWAY
        bridge-ports eth0
        bridge-stp off
        bridge-fd 0
EOF

# Configure hosts file
echo "Configuring /etc/hosts file..."
cat <<EOF | sudo tee /etc/hosts
127.0.0.1    localhost
$BASE_IP    raspberrypi
EOF

# Set up the bridge
echo "Setting up the bridge interface..."
sudo brctl addbr vmbr0
sudo brctl addif vmbr0 eth0
sudo ip addr add $STATIC_IP dev vmbr0
sudo ip link set vmbr0 up

# Download Pimox installation script
echo "Downloading Pimox installation script..."
curl -s https://raw.githubusercontent.com/pimox/pimox7/master/RPiOS64-IA-Install.sh -o RPiOS64-IA-Install.sh
chmod +x RPiOS64-IA-Install.sh

# Retry logic for Pimox installation
retry_limit=3
retry_count=0

while [ $retry_count -lt $retry_limit ]; do
    echo "Running Pimox installation script (Attempt $((retry_count + 1)) of $retry_limit)..."
    ./RPiOS64-IA-Install.sh

    if [ $? -eq 0 ]; then
        echo "Pimox installation completed successfully."
        break
    else
        echo "Pimox installation failed."
        retry_count=$((retry_count + 1))

        if [ $retry_count -lt $retry_limit ]; then
            echo "Retrying in 3 seconds..."
            for i in {3..1}; do
                echo "$i..."
                sleep 1
            done
        else
            echo "Reached retry limit. Pimox installation failed. Exiting."
            exit 1
        fi
    fi
done

# Run rpi-connect signin
echo "Signing in with rpi-connect..."
sudo rpi-connect signin

echo "Script completed successfully!"
