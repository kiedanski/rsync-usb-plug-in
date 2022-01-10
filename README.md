# rsync-usb-plug-in
The goal of this project is to provide a template for setting up scripts (possible long ones) that run whenever a specific device is connected via usb

## Usage

The first thing that you need to do is to open the `variables` file and change the values in there to reflect your own device.

There are a couple of commands that can be used to get information about your usb device:

```bash
lsusb
```

and then

```bash
lsusb -D /dev/bus/usb/00X/00Y # where X and Y are given by lsusb
```

alternatively you can also use:

```bash
udevadm info -q all -a /dev/sdXY
```

Once you have updated the variables file, simply run the install command and reboot.
The install command also generates an uninstall.sh file that can be used to remove the project entirely.

