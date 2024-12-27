# pimox-raspberrypi-5
Install Proxmox on a raspberrypi 5

Run the following commands to have proxmox on a raspberrypi 5 ^^

## updates the resporitory list and updates the pi
apt update && apt upgrade -y

## Installs RPi-Connect so that you can access your Raspberry Pi from the internet at [https](https://connect.raspberrypi.com)
apt install rpi-connect-lite

## Turns the RPi-Connect on
rpi-connect on

## Connects your RPi-Connect to your Raspberry account
rpi-connect signin

## Downloads the Proxmox repository
curl http://global.mirrors.apqa.cn/proxmox/debian/pveport.gpg -o /etc/apt/trusted.gpg.d/pveport.gpg

## Adds the download to the repository list
echo "deb [arch=arm64] http://global.mirrors.apqa.cn/proxmox/debian/pve bookworm port" | sudo tee -a /etc/apt/sources.list

## Checks the repository list for new downloads
apt update

## Updates the pi
apt dist-upgrade -y

## Edit the interface file
nano /etc/network/interfaces

## Put this in your interfaces file and change the ip and gateway
auto lo
iface lo inet loopback

iface eth0 inet manual

auto vmbr0
iface vmbr0 inet static
        address 192.168.68.71/24
        gateway 192.168.68.1
        bridge-ports eth0
        bridge-stp off
        bridge-fd 0

## Edit the host file and change the ip to your Raspberry Pi ip
nano /etc/hosts

127.0.0.1	localhost
192.168.68.71	rasberrypi

## Adds the vmbr0 Bridge
sudo brctl addbr vmbr0

sudo brctl addif vmbr0 eth0

## Change the ip to your Raspberry Pi ip
sudo ip addr add 192.168.68.71/24 dev vmbr0

sudo ip link set vmbr0 up

## Download the Pimox install script
curl https://raw.githubusercontent.com/pimox/pimox7/master/RPiOS64-IA-Install.sh > RPiOS64-IA-Install.sh

## Makes the install script that it can run
chmod +x RPiOS64-IA-Install.sh

## Runs the Pimox script
./RPiOS64-IA-Install.sh
