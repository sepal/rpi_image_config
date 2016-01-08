# Commands

## Run the Docker image
docker run --privileged -i -t --rm -v ~/Work/Docker/rpi_config/images:/opt/images ubuntu /bin/bash

## Mount an image
Taken from [this stackoverflow thread](https://unix.stackexchange.com/questions/82314/how-to-find-the-type-of-img-file-and-mount-it).

Check the image file:
`sudo fdisk -lu /opt/images/2015-11-21-raspbian-jessie.img`

This will the us the block size:
`Units = sectors of 1 * 512 = 512 bytes`

and also the sectors which the image contain and where they start:
```
                                Device Boot           Start         En       Blocks   Id  System
/opt/images/2015-11-21-raspbian-jessie.img1            8192      131071       61440    c  W95 FAT32 (LBA)
/opt/images/2015-11-21-raspbian-jessie.img2          131072     7684095     3776512   83  Linux
```

With this information we can calculate the offset for the mount command:
- Block size is 512 and the root partition (i.e. the second in the list) starts at
131072.
- The offset is therefore 512 * 131072 = 67108864

With the offset we can now mount the root partition from the image:
`mount -t auto -o loop,offset=67108864 /opt/images/2015-11-21-raspbian-jessie.img /mnt/`

## Configure wifi (wpa)
Taken from the [Raspberry Pi homepage](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md)

Edit the wpa_supplicant conf:
`vim /mnt/etc/wpa_supplicant/wpa_supplicant.conf`

Insert ESSID and password:
```
network={
    ssid="The_ESSID_from_earlier"
    psk="Your_wifi_password"
}
```

## Write the image (MacOsX)
Taken from the [Raspberry Pi homepage](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)

Identify the disk
`diskutil list`

Unmount the disk
`diskutil unmountDisk /dev/disk<disk# from diskutil>`

Copy the image to the disk:
`sudo dd bs=1m if=image.img of=/dev/rdisk<disk# from diskutil>`
