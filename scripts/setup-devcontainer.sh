#!/bin/bash
# SPDX-License-Identifier: GPL-3.0

set -euxo pipefail

: "${ARCH:=$(dpkg --print-architecture)}"
: "${BUF_VERSION:=1.36.0}"
: "${SBCTL_VERSION:=0.15.4}"

# configure environment
[[ ! -d /home/vscode/.oh-my-zsh ]] &&
  sh -c "$(curl -fsSLo /home/vscode/.oh-my-zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo mkdir -p /home/vscode/.ssh

sudo ln -sf /workspace/config/zshrc /root/.zshrc
sudo ln -sf /workspace/config/zshrc /home/vscode/.zshrc
sudo ln -sf /workspace/config/sshconfig /home/vscode/.ssh/config
sudo ln -sf /workspace/config/gitconfig /home/vscode/.gitconfig

sudo ln -sf /workspace/scripts/aliases.sh /etc/profile.d/aliases.sh
sudo ln -sf /workspace/scripts/environment.sh /etc/profile.d/environment.sh

sudo sed -i 's/bash/zsh/g' /etc/passwd
sudo chown -R vscode:vscode /home/vscode/

source /etc/profile

# install packages
sudo apt-get update -y
sudo apt-get install -y \
  binwalk \
  bison \
  build-essential \
  clang \
  dkms \
  file \
  flex \
  gcc \
  golang \
  libelf-dev \
  libssl-dev \
  lld \
  llvm \
  nodejs \
  npm \
  protobuf-compiler \
  protobuf-compiler-grpc \
  qemu-system

sudo -E mkdir -p \
  "${CARGO_HOME}" \
  "${RUSTUP_HOME}" \
  "${GOPATH}"

# install sbctl
[[ -z $(command -v sbctl) ]] && {
  curl -fsSLo "/tmp/sbctl-${SBCTL_VERSION}-linux-${ARCH}.tar.gz" "https://github.com/Foxboron/sbctl/releases/download/${SBCTL_VERSION}/sbctl-${SBCTL_VERSION}-linux-${ARCH}.tar.gz"
  tar -xvf "/tmp/sbctl-${SBCTL_VERSION}-linux-${ARCH}.tar.gz" -C /tmp/
  sudo -E install /tmp/sbctl/sbctl /usr/local/bin/
  sbctl status || true
}

# install buf
[[ -z $(command -v buf) ]] && {
  curl -fsSLo "/tmp/buf-$(uname -s)-$(uname -m)" "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m)"
  sudo -E install "/tmp/buf-$(uname -s)-$(uname -m)" /usr/local/bin/buf
  buf --version
}

# install rust
[[ -z $(command -v rustc) ]] && {
  curl -fsSLo /tmp/rustup-init.sh https://sh.rustup.rs
  sudo -E RUSTUP_HOME="${RUSTUP_HOME}" CARGO_HOME="${CARGO_HOME}" sh /tmp/rustup-init.sh -y
  # rustup default nightly
  # rustup component add x86_64-unknown-none
  rustup component add rust-src
  cargo install cargo-bundle
  rustc --version
  cargo --version
}

# install trunk.io
[[ -z $(command -v trunk) ]] && {
  curl https://get.trunk.io -fsSL | sudo bash
  sudo -E chmod 755 "$(command -v trunk)"
  trunk --version
}

# install k0s
[[ -z $(command -v k0s) ]] && curl -fsSL https://get.k0s.sh | sudo sh
[[ -z $(sudo k0s status) ]] && {
  sudo k0s install controller --single --config config/k0s.yaml
  sudo k0s start
}
sudo k0s kubeconfig admin | tee hack/kubeconfig.yaml
sed -i 's/server: https.*/server: https:\/\/127.0.0.1:16443/g' hack/kubeconfig.yaml

# post
sudo -E chmod -R 777 "${RUSTUP_HOME}" "${CARGO_HOME}"

# cleanup
rm -f /tmp/rustup-init.sh
rm -f /tmp/buf-*
rm -rf /tmp/sbctl*
