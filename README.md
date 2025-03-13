📜 Digi Install Windows
🚀 Automated Windows Installation on VPS using QEMU & KVM

🛠 Features
✅ Automatic QEMU & KVM Installation – No manual setup required
✅ Windows ISO Auto-Download – Latest version from Microsoft
✅ Optimized Disk Image – Creates a 30GB raw image
✅ VNC Access for GUI Installation – Easy Windows setup
✅ VirtIO Drivers Included – Enhanced performance

📌 Requirements
🔹 VPS with Root Access
🔹 KVM Support (lsmod | grep kvm)
🔹 At least 30GB of free disk space
🔹 Ubuntu/Debian-based OS

🚀 Installation Guide
1️⃣ Clone the Repository
```bash
git clone https://github.com/sipenhd/digi-install-windows.git
cd digi-install-windows

2️⃣ Run the Script

```bash
chmod +x install_windows.sh
sudo ./install_windows.sh

3️⃣ Connect via VNC
Once the script is executed, you can connect via VNC Viewer using your VPS IP and port :1.
?? File Structure
```bash 
?? digi-install-windows
 ┣ ?? install_windows.sh   # Main installation script
 ┣ ?? README.md            # Documentation
 ┣ ?? assets               # Images, logos, or additional resources

