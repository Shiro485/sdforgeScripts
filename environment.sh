#!/bin/bash

# Resolve script directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/system" && pwd)"

# Prepend paths
export PATH="$DIR/git/bin:$DIR/python/Python-3.10.6:$DIR/python/Python-3.10.6/Scripts:$PATH"

# Set environment variables
export PY_LIBS="$DIR/python/Scripts/Lib:$DIR/python/Scripts/Lib/site-packages"
export PY_PIP="$DIR/python/Scripts"
export SKIP_VENV=1
export PIP_INSTALLER_LOCATION="$DIR/python/get-pip.py"
export TRANSFORMERS_CACHE="$DIR/transformers-cache"
