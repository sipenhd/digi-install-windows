#!/bin/bash

# Update dan Install QEMU
echo "Updating system..."
apt update && apt install -y qemu-utils qemu-system-x86 wget xrdp git

# Download Windows Ghost Spectre ISO
echo "Downloading Windows Ghost Spectre ISO..."
wget -O /root/windows.iso "https://archive.org/download/ghost-spectre-windows-10/GhostSpectreWindows10SuperLite.iso"

# Konfigurasi Disk untuk Windows
echo "Setting up disk..."
qemu-img create -f qcow2 /root/windows.qcow2 50G

# Menjalankan Instalasi Windows di QEMU
echo "Starting Windows installation..."
nohup qemu-system-x86_64 -enable-kvm -m 8000 -cpu host -smp 4 \
  -cdrom /root/windows.iso -boot d -drive file=/root/windows.qcow2,format=qcow2 \
  -net user,hostfwd=tcp::3389-:3389 -net nic -vga std -vnc :1 \
  > /dev/null 2>&1 &

echo "Installation started. Connect via VNC to complete setup."
echo "To connect: Use VNC Viewer with IP:PORT"
echo "After installation, run Windows setup manually."

