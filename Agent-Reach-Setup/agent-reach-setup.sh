#!/bin/bash
# Agent Reach setup for Claude Code cloud sessions.
set -euo pipefail

AR_DIR=/home/user/Agent-Reach

# 1. Clone and install Agent Reach into its own virtualenv
if [ ! -d "$AR_DIR/.git" ]; then
  git clone --depth 1 https://github.com/Panniantong/Agent-Reach.git "$AR_DIR"
fi
python3 -m venv "$AR_DIR/.venv"
"$AR_DIR/.venv/bin/python" -m pip install --quiet --upgrade pip
"$AR_DIR/.venv/bin/python" -m pip install --quiet -c "$AR_DIR/constraints.txt" -e "$AR_DIR[dev]"
ln -sf "$AR_DIR/.venv/bin/agent-reach" /usr/local/bin/agent-reach
ln -sf "$AR_DIR/.venv/bin/yt-dlp" /usr/local/bin/yt-dlp

# 2. YouTube: give yt-dlp a JS runtime
mkdir -p /root/.config/yt-dlp
grep -qxF -- '--js-runtimes node' /root/.config/yt-dlp/config 2>/dev/null \
  || printf '%s\n' '--js-runtimes node' >> /root/.config/yt-dlp/config

# 3. Exa semantic search via mcporter
npm install -g mcporter
mcporter config add exa https://mcp.exa.ai/mcp --scope home
# Make Node's fetch use the environment's HTTPS proxy
grep -qxF 'export NODE_USE_ENV_PROXY=1' /root/.bashrc 2>/dev/null \
  || echo 'export NODE_USE_ENV_PROXY=1' >> /root/.bashrc
