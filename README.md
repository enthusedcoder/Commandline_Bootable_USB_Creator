# Command line bootable USB flash drive utility

This command line utility will format any indicated USB flash drive in such a way as to make it bootable.  Then, just copy the contents of a bootable disk to the formatted flash drive, and you will then be able to boot the media from the USB drive

# Disclaimer

**This tool will format your USB Flash drive in order to make it bootable.  This means that any content on the flash drive at the time this tool is used will be erased.  I am not responisble for any lost data associated with the misuse of this tool, based on ignorance or otherwise.  Use at your own risk.**

## How to use

usbformat.exe `<DriveLetter`>

`<DriveLetter`> = The letter associated with the USB Flash Drive which you want to format.

**Example**

usbformat.exe F