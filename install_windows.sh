#!/bin/bash

# Update package repositories
apt-get update && apt-get upgrade -y

# Install QEMU and necessary packages
sudo apt-get install qemu-kvm qemu-utils qemu-system-x86 qemu-system-gui -y

echo "QEMU installation completed successfully."

# Set Windows installation parameters
IMG_FILE="windows.img"
ISO_FILE="windows.iso"
ISO_LINK="https://go.microsoft.com/fwlink/p/?LinkID=2208844&clcid=0x409&culture=en-us&country=US"
VIRTIO_ISO="virtio-win.iso"
VIRTIO_LINK="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-1/virtio-win-0.1.215.iso"

# Create a raw image for Windows
qemu-img create -f raw "$IMG_FILE" 40G

echo "Image file $IMG_FILE created successfully."

# Download Windows ISO
wget -O "$ISO_FILE" "$ISO_LINK" || { echo "Failed to download $ISO_FILE"; exit 1; }
echo "Windows ISO downloaded successfully."

# Download VirtIO drivers
wget -O "$VIRTIO_ISO" "$VIRTIO_LINK" || { echo "Failed to download $VIRTIO_ISO"; exit 1; }
echo "VirtIO drivers downloaded successfully."

# Start Windows installation in QEMU
qemu-system-x86_64 -enable-kvm -m 4096 -cpu host -smp 2 \
    -drive file="$IMG_FILE",format=raw \
    -cdrom "$ISO_FILE" -boot d -vnc :1 \
    -device VGA -vga std \
    -net nic -net user

echo "QEMU Windows installation started. Connect via VNC to continue."
