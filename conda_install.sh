#!/usr/bin/env bash
# Minimal Miniconda installer for Ubuntu 24.04 (x86_64).
# Run:
#   chmod +x conda_install.sh
#   sudo ./conda_install.sh

set -euo pipefail
[ "${EUID}" -eq 0 ] || { echo "Run as root: sudo $0" >&2; exit 1; }
source /etc/os-release
[ "${ID:-}" = "ubuntu" ] && [ "${VERSION_ID:-}" = "24.04" ] || { echo "Ubuntu 24.04 only" >&2; exit 1; }

INSTALL_DIR="${CONDA_PREFIX:-/opt/miniconda3}"
INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_PATH="/tmp/miniconda.sh"

echo "==> Downloading Miniconda installer"
curl -fsSL "${INSTALLER_URL}" -o "${INSTALLER_PATH}"

echo "==> Installing Miniconda to ${INSTALL_DIR}"
bash "${INSTALLER_PATH}" -b -u -p "${INSTALL_DIR}"
rm -f "${INSTALLER_PATH}"

echo "==> Creating conda symlink in /usr/local/bin"
ln -sf "${INSTALL_DIR}/bin/conda" /usr/local/bin/conda

echo "==> Initializing shell hook (bash)"
"${INSTALL_DIR}/bin/conda" init bash >/dev/null 2>&1 || true

echo "==> Done. Usage:"
echo "  conda --version"
echo "  source ~/.bashrc  # to load conda hook"

