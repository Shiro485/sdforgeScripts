#!/usr/bin/env bash

# Equivalent of variable resets
#PYTHON=""
#GIT=""
#VENV_DIR=""

# Base command-line arguments
COMMANDLINE_ARGS="--cuda-malloc --xformers --disable-gpu-warning"

# Append checkpoint and Lora directories
COMMANDLINE_ARGS="$COMMANDLINE_ARGS \
    --ckpt-dir \"$HOME/Documents/stable-diffusion-webui-master/models/Stable-diffusion\" \
    --lora-dir \"$HOME/Documents/stable-diffusion-webui-master/models/Lora\""

# Launch main webui script
exec "$(dirname "$0")/webui.sh" $COMMANDLINE_ARGS