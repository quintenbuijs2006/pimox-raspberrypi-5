# pimox-raspberrypi-5
Install Proxmox on a raspberrypi 5

Install This OS via the Raspberry Pi Imager

## Go to Raspberry Pi OS (other)
![image](https://github.com/user-attachments/assets/f7b947ac-93e5-4760-bef2-cdc76a4c973c)

## Select Raspberry PI OS Lite (64-bit)
![image](https://github.com/user-attachments/assets/a90adb04-5552-4803-981d-3532a17063c0)

When the settings show up press edit and enable ssh then put a username and password in there you want to use

# Run the following commands to have proxmox on a raspberrypi 5 ^^

If the RPi-Connect doesnt want to start reinstall the entire OS and do the ```sudo -s``` & ```apt update && apt upgrade -y``` later and run that command with sudo as user account

## makes the commands so you dont have to use sudo
```sudo -s```

## updates the resporitory list and updates the Pi
```sudo apt update && apt upgrade -y```

## Installs RPi-Connect so that you can access your Raspberry Pi from the internet at [Raspberry Pi Connect Site](https://connect.raspberrypi.com)
```sudo apt install rpi-connect-lite```

## Turns the RPi-Connect on
```rpi-connect on```

## Connects your RPi-Connect to your Raspberry account
```rpi-connect signin```

## Enable User-Lingering to access your Raspberry Pi when no user is logged in
```loginctl enable-linger```

## Downloads the Proxmox repository
```sudo curl http://global.mirrors.apqa.cn/proxmox/debian/pveport.gpg -o /etc/apt/trusted.gpg.d/pveport.gpg```

## Adds the download to the repository list
```echo "deb [arch=arm64] http://global.mirrors.apqa.cn/proxmox/debian/pve bookworm port" | sudo tee -a /etc/apt/sources.list```

## Checks the repository list for new downloads
```sudo apt update```

## Updates the Pi
```sudo apt dist-upgrade -y```

## Edit the interface file
```sudo nano /etc/network/interfaces```

## Put this in your interfaces file and change the ip and gateway
![image](https://github.com/user-attachments/assets/c523b337-c890-4937-af00-af8df9198aff)

## Edit the hosts file
```sudo nano /etc/hosts```

## Install the pve-qemu-kvm package
```sudo apt install pve-qemu-kvm```

## Install the proxmox-ve package
```sudo apt install proxmox-ve```

## Reboot your server
```reboot```

## Edit the host file and change the ip to your Raspberry Pi ip
![image](https://github.com/user-attachments/assets/5eee3c12-7cab-4c66-a65c-c521d8bc3694)

## Install the Bridge-Utils package
```sudo apt install bridge-utils -y```

## Adds the vmbr0 Bridge
```sudo brctl addbr vmbr0```

```sudo brctl addif vmbr0 eth0```

## Change the ip to your Raspberry Pi ip
```sudo ip addr add 192.168.68.71/24 dev vmbr0```

```sudo ip link set vmbr0 up```

## Download the Pimox install script
```sudo curl https://raw.githubusercontent.com/pimox/pimox7/master/RPiOS64-IA-Install.sh > RPiOS64-IA-Install.sh```

## Makes the install script that it can run
```sudo chmod +x RPiOS64-IA-Install.sh```

## Runs the Pimox script
```sudo ./RPiOS64-IA-Install.sh```

## Reboot the server
```reboot```

## Makes the commands so you dont have to use sudo
```sudo -s```

## Updates the pi
```sudo apt upgrade -y```

## In the proxmox shell run this command
```sudo bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/pimox-haos-vm.sh)"```

Now stop the vm.
In the VM options, enable QEMU Guest Agent.
In the VM options, resize the disk. Either 24 or 32 are okay. More than that and it’s overkill.
NOTE: THE “increment” IS THE AMOUNT THAT WILL ADD OVER THE EXISTING DISK.
If you are running the 4GB model or plan on running more VMs, in the options menu, set the
allocated RAM to 2 GB.
