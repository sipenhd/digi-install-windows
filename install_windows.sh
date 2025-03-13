#!/bin/bash

# Update package repositories and upgrade existing packages
if ! apt-get update && apt-get upgrade -y; then
    echo "Failed to update packages. Exiting."
    exit 1
fi

# Install QEMU and its utilities
if ! apt-get install qemu qemu-utils qemu-system-x86-xen qemu-system-x86 qemu-kvm -y; then
    echo "Failed to install QEMU. Exiting."
    exit 1
fi

echo "QEMU installation completed successfully."

# Set variables for the Windows ISO
img_file="windows_server.img"
iso_link="https://bit.ly/3gN5xrh"
iso_file="windows_server.iso"

# Create a raw image file
if ! qemu-img create -f raw "$img_file" 50G; then
    echo "Failed to create image file. Exiting."
    exit 1
fi

echo "Image file $img_file created successfully."

# Download Virtio driver ISO
if ! wget -O virtio-win.iso 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-1/virtio-win-0.1.215.iso'; then
    echo "Failed to download Virtio driver ISO. Exiting."
    exit 1
fi

echo "Virtio driver ISO downloaded successfully."

# Download Windows ISO from the provided link
if ! wget -O "$iso_file" "$iso_link"; then
    echo "Failed to download Windows ISO. Exiting."
    exit 1
fi

echo "Windows ISO downloaded successfully."

# Optional: Add instructions to run the virtual machine
echo "Setup completed successfully!"
echo "You can now run the virtual machine using the following command:"
echo "qemu-system-x86_64 -hda $img_file -cdrom $iso_file -boot d -m 4096"
