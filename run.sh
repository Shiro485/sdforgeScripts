#!/bin/bash
# Equivalent of the Windows batch script

# Source environment setup
source "$(dirname "$0")/environment.sh"

# Change to the webui directory (relative to script)
cd "$(dirname "$0")/webui" || exit 1

# Run the user startup script
exec ./webui-user.sh