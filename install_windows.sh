#!/bin/bash

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo "Silakan jalankan script ini dengan sudo!"
    exit 1
fi

echo "Menginstal QEMU dan dependensi..."
sudo apt-get update
sudo apt-get install -y qemu-kvm qemu-utils qemu-system-x86 wget curl || { echo "Gagal menginstal QEMU!"; exit 1; }
echo "QEMU berhasil diinstal."

# Set parameter instalasi
IMG_FILE="windows.img"
ISO_FILE="windows.iso"
ISO_LINK="https://go.microsoft.com/fwlink/p/?linkid=2195333"
VIRTIO_ISO="virtio-win.iso"
VIRTIO_LINK="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"

# Ukuran disk bisa dikustomisasi (default 40GB)
IMG_SIZE=${1:-40G}

echo "Membuat file image $IMG_FILE dengan ukuran $IMG_SIZE..."
qemu-img create -f raw "$IMG_FILE" "$IMG_SIZE" || { echo "Gagal membuat image file!"; exit 1; }
echo "File image $IMG_FILE berhasil dibuat."

# Download Windows ISO
echo "Mengunduh Windows ISO dari Microsoft..."
wget -O "$ISO_FILE" "$ISO_LINK" || { echo "Gagal mengunduh Windows ISO!"; exit 1; }
echo "Windows ISO berhasil diunduh."

# Validasi apakah file terunduh dengan benar
if [ ! -f "$ISO_FILE" ]; then
    echo "File ISO Windows tidak ditemukan! Periksa kembali link atau coba lagi nanti."
    exit 1
fi

# Download VirtIO Drivers
echo "Mengunduh VirtIO Drivers..."
wget -O "$VIRTIO_ISO" "$VIRTIO_LINK" || { echo "Gagal mengunduh VirtIO drivers!"; exit 1; }
echo "VirtIO Drivers berhasil diunduh."

# Validasi apakah file VirtIO terunduh dengan benar
if [ ! -f "$VIRTIO_ISO" ]; then
    echo "File VirtIO tidak ditemukan! Periksa kembali link atau coba lagi nanti."
    exit 1
fi

# Menjalankan QEMU untuk instalasi Windows
echo "Memulai instalasi Windows di QEMU..."
qemu-system-x86_64 -enable-kvm -m 4096 -cpu host -smp 2 \
    -drive file="$IMG_FILE",format=raw \
    -cdrom "$ISO_FILE" -boot d \
    -vga qxl \
    -display vnc=:1 \
    -netdev user,id=network0 -device virtio-net,netdev=network0

echo "Instalasi Windows telah dimulai. Gunakan VNC untuk mengaksesnya (port :1)."
