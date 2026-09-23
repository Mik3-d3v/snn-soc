#!/usr/bin/env bash
set -euo pipefail

# cnn-soc/install.sh
# Installs: Verilator, riscv-gnu-toolchain (elf/bare-metal), gtkwave
# Target: Ubuntu 22.04 (native or WSL2)

REQUIRED_VERILATOR="v5.026"
RISCV_TOOLCHAIN_URL="https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2024.09.03/riscv32-elf-ubuntu-22.04-gcc-nightly-2024.09.03-nightly.tar.gz"
RISCV_INSTALL_DIR="/opt/riscv"

log() { printf "\n[cnn-soc] %s\n" "$1"; }

# --- sanity checks ---------------------------------------------------------
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: this script targets Ubuntu 22.04 (native or WSL2). Detected: $OSTYPE"
    exit 1
fi

if grep -qi microsoft /proc/version; then
    log "Detected: WSL"
else
    log "Detected: native Linux"
fi

# --- 1. base packages -------------------------------------------------------
log "Installing base packages..."
sudo apt update
sudo apt install -y \
    git make autoconf g++ flex bison \
    libfl2 libfl-dev help2man perl python3 \
    ccache libgoogle-perftools-dev numactl wget gtkwave

# --- 2. verilator (build from source, pinned version) -----------------------
if command -v verilator &>/dev/null && verilator --version | grep -q "${REQUIRED_VERILATOR#v}"; then
    log "Verilator ${REQUIRED_VERILATOR} already installed, skipping"
else
    log "Building Verilator ${REQUIRED_VERILATOR} from source..."
    BUILD_DIR="$(mktemp -d)"
    git clone -q https://github.com/verilator/verilator "$BUILD_DIR"
    (
        cd "$BUILD_DIR"
        git checkout -q "$REQUIRED_VERILATOR"
        autoconf
        ./configure
        make -j"$(nproc)"
        sudo make install
    )
    rm -rf "$BUILD_DIR"
    log "Verilator installed: $(verilator --version)"
fi

# --- 3. riscv-gnu-toolchain (prebuilt, bare-metal elf) -----------------------
if command -v riscv32-unknown-elf-gcc &>/dev/null; then
    log "riscv32-unknown-elf-gcc already on PATH, skipping"
else
    log "Downloading riscv-gnu-toolchain (elf/bare-metal)..."
    TARBALL="$(mktemp).tar.gz"
    wget -q -O "$TARBALL" "$RISCV_TOOLCHAIN_URL"
    sudo mkdir -p "$RISCV_INSTALL_DIR"
    sudo tar -xzf "$TARBALL" -C "$RISCV_INSTALL_DIR" --strip-components=1
    rm -f "$TARBALL"

    if ! grep -q "$RISCV_INSTALL_DIR/bin" ~/.bashrc; then
        echo "export PATH=\"$RISCV_INSTALL_DIR/bin:\$PATH\"" >> ~/.bashrc
    fi
    export PATH="$RISCV_INSTALL_DIR/bin:$PATH"
    log "Toolchain installed: $(riscv32-unknown-elf-gcc --version | head -n1)"
fi

# --- done --------------------------------------------------------------------
log "Setup complete. Run 'source ~/.bashrc' or open a new shell, then verify with:"
echo "    verilator --version"
echo "    riscv32-unknown-elf-gcc --version"
echo "    gtkwave --version"
