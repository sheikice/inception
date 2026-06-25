#!/usr/bin/env bash
set -euo pipefail

GOINFRE=$HOME/goinfre
# Config
# ==================
USERNAME="jwuille"
PASSWORD="tochange"
VM_NAME="inception42"
RAM=4096
CPUS=2
DISK_SIZE_MB=9000

PATH_VM=$GOINFRE
# PATH_VM=$HOME
# ==================

DEBIAN_VERSION="12.11.0"
ISO_NAME="debian-${DEBIAN_VERSION}-amd64-netinst.iso"
ISO_DIR="${PATH_VM}/iso"
ISO="$ISO_DIR/$ISO_NAME"
ISO_URL="https://cdimage.debian.org/mirror/cdimage/archive/${DEBIAN_VERSION}/amd64/iso-cd/${ISO_NAME}"

mkdir -p "$ISO_DIR"

if VBoxManage list vms | grep -q "\"$VM_NAME\""; then
    echo "Removing existing VM..."
    VBoxManage controlvm "$VM_NAME" poweroff 2>/dev/null || true
    while VBoxManage list runningvms | grep -q "\"$VM_NAME\""; do
        echo "Waiting for VM to stop..."
        sleep 2
    done
    VBoxManage unregistervm "$VM_NAME" --delete
fi

if [ ! -f "$ISO" ]; then
    echo "Downloading Debian ISO..."
    curl -L "$ISO_URL" -o "$ISO"
fi

VBoxManage createvm --name "$VM_NAME" --ostype Debian_64 --register
VBoxManage modifyvm "$VM_NAME" \
  --memory "$RAM" \
  --cpus "$CPUS" \
  --nic1 nat \
  --boot1 dvd \
  --boot2 disk
VBoxManage modifyvm "$VM_NAME" \
  --natpf1 "ssh,tcp,,2222,,22" \
  --natpf1 "http,tcp,,8080,,80" \
  --natpf1 "https,tcp,,8443,,443"
VBoxManage createhd \
  --filename "${PATH_VM}/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" \
  --size "$DISK_SIZE_MB" \
  --format VDI
VBoxManage storagectl "$VM_NAME" \
  --name "SATA Controller" \
  --add sata \
  --controller IntelAhci
VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA Controller" \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium "${PATH_VM}/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium "$ISO"

# Post-install provisioning script.
# ===================================================================
SCRIPT=$(cat <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

sed -i '/^deb cdrom:/s/^/#/' /etc/apt/sources.list

# Base packages
apt-get update
apt-get install -y --no-install-recommends \
    sudo \
    openssh-server \
    curl \
    gpg \
    firefox-esr \
    git \
    make \
	ftp \
    ca-certificates

# Docker repo setup
curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

apt-get update && apt-get install -y --no-install-recommends \
    docker.io \
    docker-compose-plugin

# User setup
usermod -aG sudo,docker "${USERNAME}"

# /etc/hosts
sed -i "s/localhost/localhost ${USERNAME}.42.fr/" /etc/hosts

# SSH X11 forwarding
sed -i '/^X11Forwarding/d; /^#X11Forwarding/d' /etc/ssh/sshd_config
echo 'X11Forwarding yes' >> /etc/ssh/sshd_config

sed -i '/^X11UseLocalhost/d; /^#X11UseLocalhost/d' /etc/ssh/sshd_config
echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config

systemctl enable ssh docker

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
)
# ===================================================================


SCRIPT_B64=$(printf '%s' "$SCRIPT" | base64 -w0)

# Boot the VM
AUX_DIR="$(mktemp -d /tmp/inception42-unattended-XXXXXX)"
VBoxManage unattended install "$VM_NAME" \
  --iso="$ISO" \
  --user="$USERNAME" \
  --password="$PASSWORD" \
  --full-user-name="Inception User" \
  --hostname="${VM_NAME}.local" \
  --time-zone="Europe/Paris" \
  --locale="en_US" \
  --country="FR" \
  --package-selection-adjustment=minimal \
  --auxiliary-base-path="$AUX_DIR/" \
  --post-install-command="chroot /target /bin/bash -c \"echo ${SCRIPT_B64} | base64 -d > /root/setup.sh && chmod +x /root/setup.sh && USERNAME=${USERNAME} /root/setup.sh\"" \
  --start-vm=gui
