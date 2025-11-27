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
- Binary Installation
	- `sudo pacman -U albert-x.xx.x-0x86_64.pkg.tar.zst` 
	- Done, but no updates 
- Adding package doesnt work, build fails

## Nvidia Setup (for second monitor)
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

## QEMU Setup
- Making Virtual Disk : `qemu-img create -f qcow2 /path/to/distro.qcow2 50G`
- Installing VM's :
	```bash
	virt-install \
	--name Arch \
	--memory 8192 \ 
	--vcpus 8 \
	--cpu host-passthrough, cache.mode=passthrough \
	--machine q35 \
	--disk path=/home/atharv/arch.qcow2,format=qcow2,bus=virtio,cache=none,discard=unmap,io=native \
	--cdrom /home/atharv/archlinux-2025.08.01-x86_64.iso \
	--network network=default,model=virtio \
	--graphics spice \
	--video virtio \ 
	--channel spicevmc \
	--boot uefi \
	--features kvm_hidden=on 
	```
- List all VMs : `virsh list --all`
- Running VM : `virsh start <name> & virt-viewer <name> & disown`
- Shutting Down VM : `sudo virsh destroy <name>`
- Editing VM configs : `virsh edit <name>`
- Removing VM : `sudo virsh undefine <name> --nvram & sudo rm /path/to/<name>.qcow2` 
- USB Passthrough:
	- `lsusb` : `Bus 001 Device 005: ID 046d:c534 Logitech USB Receiver`
	- There will be multiple devices, like this, the ID is whats important `046d:c534`
	- Command to attach device
		```bash
		virsh attach-device Arch <(echo "
		<hostdev mode='subsystem' type='usb' managed='yes'>
		<source>
			<vendor id='0x046d'/> # replace this with desired
			<product id='0xc534'/> # usb vendor id and product id
		</source>
		</hostdev>
		") --live
		```
	- Command to detach device (simple replace `attach-device` with `detach-device`)
- Windows: Just use virtual machine manager, too much bt to do cli

## Creating a Modified ISO
- 7z x <iso_name>.iso -oisoroot
- ISO is extracted in /isoroot, now do any modifications necessary (eg: add xml)
- Then Run: to rebuild the iso with the modifications
	```bash
	xorriso -as mkisofs \
	-iso-level 3 -full-iso9660-filenames \
	-volid "<custom_iso_name_withou_file_extention>" \
	-eltorito-boot boot/etfsboot.com \
		-no-emul-boot -boot-load-size 8 -boot-info-table \
	-eltorito-alt-boot \
		-eltorito-boot efi/microsoft/boot/efisys.bin \
		-no-emul-boot -isohybrid-gpt-basdat \
	-o Win11_Unattended.iso isoroot
	```



## Monitor Setup
- Making a virtual monitor
	- `hyprctl output create headless ghost`
	- set monitor specifications in `hyprland.conf`

## Pinning in Thunar (Bookmarks)
- Go inside which ever folder u want to pin and 
- `ctrl + d` 
- This creates a shortcut to that folder which can be renamed to whatever
- And it doesnt change the name of the actual folder

## Root Tablet
1. Install adb `sudo pacman -S android-tools`
2. Enable Developer Options & Turn on OEM Unlocking + USB Debugging in Developer Options
3. `adb devices` to check if adb has control over tablet
4. `adb reboot bootloader` this will reboot android into fastboot i.e. bootloader
5. after a little while, when device is stuck i.e. in bootloader `fastboot devices` to make sure fastboot can also access the device
6. `fastboot flashing unlock` unlocks the bootloader, allows flashing
7. `fastboot getvar unlocked` a check to see if the above command worked
8. `fastboot reboot` to reboot back into android, now the bootloader is unlocked
`NOTE: UNLOCKING THE BOOTLOADER WILLL RESET THE DEVICE` 
9. For one plus devices that use oxygen OS, grab the Oxygen Updater App from their github which is accessed from the website `oxygenupdater.com` and install the apk
10. In oxygen updater, go the setting & enable `Advanced mode`
11. Go to updates and download the update.zip (update will be some jargon)
12. Give this zip file to the computer `adb pull /sdcard/update.zip` (thats the command that worked for me)
13. OPTIONAL: put this update.zip in its own folder for organization and ease of use
14. `UNZIP_DISABLE_ZIPBOMB_DETECTION=TRUE unzip 75da397c26414b658891b2cce1e9792f.zip`
15. `yay -S payload-dumper-go` needed to extract all files from payload.bin which just got extracted from the above update.zip
16. `payload-dumper-go payload.bin` this command puts all the contents of payload.bin in a folder called extracted_jargon
17. Inside the above folder there will be a bunch of .img files, we need to patch the boot.img with magisk, to enable root
Hence send the boot.img back to the tablet `adb push boot.img /sdcard/`
18. Now on the device, install the magisk apk from their github. In the app 
Magisk install > Select and Patch a File > Select the boot.img > Lets Go
This will put the patched img file in the downloads folder magisk_patched*.img
19. Copy that patched file back to the computer `adb pull /sdcard/Download/magisk_patched*.img` 
20. Now we mush flash the os with this modified img file & and also disable verification of the img at boot time
21. `adb reboot bootloader` to go back into fastboot
22. `fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img` to disable verification
23. `fastboot flash boot magisk_patched.img` to flash the modified image and enable root access
24. `fastboot reboot` to get out of bootloader after flashing, and boot into a rooted android 
25. This will most likely work, if stuck in bootloop and need to go back to fastboot, hold power+volume_down (can be volume_up in some devices)

#### Verifying Root
- `adb shell su -c id` run this on the computer (and accept via gui on phone) 
- If the output is something like : `uid=0(root) gid=0(root) groups=0(root) context=u:r:init:s0`
- Device is Successfully Rooted

#### Disabling Root
- Make sure to keep the update.zip on the device, to undo the root
- Follow the same steps we did to get the boot.img i.e.
	- copy the image to the computer
	- unzip it using the above command
	- then extract the files from payload.bin
	- then we have vanilla boot.img and vbmeta.img
- go back into the bootloader via `adb reboot bootloader`
- Run the following commands
	- `fastboot flash boot boot.img` (i.e. the vanilla boot.img)
	- `fastboot flash vbmeta vbmeta.img` (again the vanilla vbmeta.img)
	- `fastboot reboot` 
- Thats it, Root has been undone