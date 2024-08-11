# SPDX-License-Identifier: GPL-3.0

# Export environment variables
export EDITOR="vi"
export GPG_TTY="$(tty)"

# Re-export PATH
export SCRIPTS="/workspace/scripts"
export TOOLS="/workspace/tools"

export RUSTUP_HOME="/usr/local/rust/rustup"
export CARGO_HOME="/usr/local/rust/cargo"

export PATH="${CARGO_HOME}/bin:${TOOLS}${PATH:+:${PATH}}"
