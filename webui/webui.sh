#!/usr/bin/env bash
set -e

# Load optional settings file
if [ -f "webui.settings.sh" ]; then
    source "webui.settings.sh"
fi

# Default values
: "${PYTHON:=python}"
: "${VENV_DIR:=$(dirname "$0")/venv}"
: "${SD_WEBUI_RESTART:=tmp/restart}"
: "${ERROR_REPORTING:=FALSE}"

mkdir -p tmp

# Check Python
if ! "$PYTHON" -c "" >tmp/stdout.txt 2>tmp/stderr.txt; then
    echo "Couldn't launch python"
    cat tmp/stderr.txt
    exit 1
fi

# Check pip
if ! "$PYTHON" -m pip --help >tmp/stdout.txt 2>tmp/stderr.txt; then
    if [ -n "$PIP_INSTALLER_LOCATION" ]; then
        "$PYTHON" "$PIP_INSTALLER_LOCATION" >tmp/stdout.txt 2>tmp/stderr.txt || {
            echo "Couldn't install pip"
            cat tmp/stderr.txt
            exit 1
        }
    else
        echo "pip not found and no installer specified"
        cat tmp/stderr.txt
        exit 1
    fi
fi

# Skip venv logic if requested
if [ "$VENV_DIR" != "-" ] && [ "$SKIP_VENV" != "1" ]; then
    if [ ! -f "$VENV_DIR/bin/python" ]; then
        PYTHON_FULLNAME=$("$PYTHON" -c "import sys; print(sys.executable)")
        echo "Creating venv in directory $VENV_DIR using python $PYTHON_FULLNAME"
        "$PYTHON_FULLNAME" -m venv "$VENV_DIR" >tmp/stdout.txt 2>tmp/stderr.txt || {
            echo "Unable to create venv in directory $VENV_DIR"
            cat tmp/stderr.txt
            exit 1
        }
        "$VENV_DIR/bin/python" -m pip install --upgrade pip || {
            echo "Warning: Failed to upgrade pip version"
        }
    fi

    # Activate venv
    source "$VENV_DIR/bin/activate"
    PYTHON="$VENV_DIR/bin/python"
    echo "venv $PYTHON"
fi

# Accelerate path
if [ "$ACCELERATE" == "True" ]; then
    echo "Checking for accelerate"
    ACCELERATE_PATH="$VENV_DIR/bin/accelerate"
    if [ -x "$ACCELERATE_PATH" ]; then
        echo "Accelerating"
        "$ACCELERATE_PATH" launch --num_cpu_threads_per_process=6 launch.py "$@"
    else
        echo "Accelerate not found, running normally"
        "$PYTHON" launch.py "$@"
    fi
else
    "$PYTHON" launch.py "$@"
fi

# Restart handling
if [ -f "$SD_WEBUI_RESTART" ]; then
    exec "$0" "$@"
fi

echo "Launch finished."
