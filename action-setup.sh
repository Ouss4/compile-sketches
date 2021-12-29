#!/bin/sh

# Set up the Python environment for the action's script to run in

readonly PYTHON_PACKAGE_VERSION='3.8'

# https://stackoverflow.com/a/29835459
readonly SCRIPT_PATH="$(
  CDPATH='' \
  cd -- "$(
    dirname -- "$0"
  )" && (
    pwd -P
  )
)"

readonly PYTHON_COMMAND="python${PYTHON_PACKAGE_VERSION}"
readonly PYTHON_VENV_PATH="${SCRIPT_PATH}/compilesketches/.venv"
readonly PYTHON_VENV_ACTIVATE_SCRIPT_PATH="${PYTHON_VENV_PATH}/bin/activate"

# Install Python

python3 -m pip install pip setuptools wheel
python3 -m venv python${PYTHON_PACKAGE_VERSION}-venv > /dev/null

# Create Python virtual environment
"$PYTHON_COMMAND" -m venv --system-site-packages "$PYTHON_VENV_PATH"

# Activate Python virtual environment
# shellcheck source=/dev/null
. "$PYTHON_VENV_ACTIVATE_SCRIPT_PATH"

# Install Python dependencies
"$PYTHON_COMMAND" -m pip install --upgrade pip > /dev/null
"$PYTHON_COMMAND" -m pip install --quiet --requirement "${SCRIPT_PATH}/compilesketches/requirements.txt"

# Set outputs for use in GitHub Actions workflow steps
# See: https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-commands-for-github-actions#setting-an-output-parameter
echo "::set-output name=python-command::$PYTHON_COMMAND"
echo "::set-output name=python-venv-activate-script-path::$PYTHON_VENV_ACTIVATE_SCRIPT_PATH"
