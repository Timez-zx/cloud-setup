#!/usr/bin/env bash
set -euo pipefail

# Minimal headless installer: NVIDIA Driver 580 + CUDA Toolkit 13.0 (Ubuntu 24.04)
set -euo pipefail
[ "${EUID}" -eq 0 ] || { echo "Run as root: sudo $0" >&2; exit 1; }
source /etc/os-release
[ "${ID:-}" = "ubuntu" ] && [ "${VERSION_ID:-}" = "24.04" ] || { echo "Ubuntu 24.04 only" >&2; exit 1; }
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y ca-certificates curl gnupg software-properties-common pciutils build-essential dkms "linux-headers-$(uname -r)"
if apt-cache show "linux-modules-extra-$(uname -r)" >/dev/null 2>&1; then
  apt-get install -y "linux-modules-extra-$(uname -r)"
fi
lspci | grep -qi nvidia || { echo "No NVIDIA GPU found"; exit 1; }

add-apt-repository -y ppa:graphics-drivers/ppa
apt-get update -y
apt-get install -y nvidia-headless-580 nvidia-utils-580
modprobe nvidia || true
modprobe nvidia_uvm || true
nvidia-modprobe -u -c=0 || true

curl -fsSL -o /tmp/cuda-keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i /tmp/cuda-keyring.deb
apt-get update -y
apt-get install -y cuda-toolkit-13-0

nvidia-smi || true
/usr/local/cuda-13.0/bin/nvcc -V || true
echo "Done."

