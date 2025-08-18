### Booting from partition on startup (Windows into a specific folder)
- `sudo blkid` : lists all disks present on system with respective UUID & type
- `sudo nano /etc/fstab`
- Add the below line
	- `UUID=xxxx-xxxx-xxxx-xxxx  /mount/point  file-system  mounting-opt  0  0`
	- file-system : `ntfs-3g`, `ext4`, `exfat` etc..
	- mounting-opt : `defaults`, `rw`, `realtime` etc.. {use defaults as mounting option}
	- dump : 0 or 1 i.e. disable or enable backup dump utility {keep 0, no one cares}
	- file system check : 0 or 1 i.e. disables or enables fsck {keep 0, no one cares} 
	- Hence, final line :
		- `UUID=EAAE69DBAE69A0B5    /mnt/Windows    ntfs    defaults    0    0`
- To and a symbolic link to the home dir
	- `mkdir Windows`
	- `ln -s /mnt/Windows/Users/Atharv /home/atharv/Windows` 
	- `ln -s /mnt/Windows /home/atharv/Windows` 
	```bash
	atharvrawal@fedora:~/Windows$ tree
	.
	├── Atharv -> /mnt/windows/Users/Atharv
	└── windows -> /mnt/windows
	```

### Change Default D.N.S.
```bash
nmcli connection modify "$(nmcli -g NAME connection show --active | head -n1)" ipv4.dns " 1.1.1.1 8.8.8.8" ipv4.ignore-auto-dns yes
nmcli connection up "$(nmcli -g NAME connection show --active | head -n1)"
```
- Copy the whole above thing and simply paste in terminal 
- This will make the D.N.S. `1.1.1.1, 8.8.8.8` for the currently active connection

## Dwm Patches used 
- `useless gap`
- `nextprev -> shiftview`

## Touchpad enable 
- `xinput list` to list all available devices
- `xinput list-props <deviceID>` to list all available options
- `xinput set-prop <deviceID> "libinput Tapping Enabled" 1

## VS Code Setup
- Editor: Font Family : `FiraCode Nerd Font`

## Albert
- Go to the main albert page
- Getting Started->Install->Linux
- Visit OBS software center 
- Add the repo and install or just get binary (your call)
- Binary Installation
	- `sudo pacman -U albert-x.xx.x-0x86_64.pkg.tar.zst` 
	- Done, but no updates 

## Monitor
- Read the hyprland nvidia page if the below doesnt work
- All necessary packages are already installed via the install script
- Create & edit `/etc/modprobe.d/nvidia.conf`
	- Add the line: `options nvidia_drm modeset=1`
- Edit `/etc/mkinitcpio.conf`
	- In the MODULES=() array, add the following module names
	- `MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)`
- Then run `sudo mkinitcpio -P` to rebuild the kernel with these parameters
- Run the below lines to add them to evn
	- `env = LIBVA_DRIVER_NAME,nvidia`
	- `env = __GLX_VENDOR_LIBRARY_NAME,nvidia`
- Reboot

## Installing qemu


## Windows iso creation with XML

