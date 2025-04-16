#!/bin/bash -e

# Get the directory of this script.
# Reference: https://stackoverflow.com/q/59895
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

# Change to the root directory.
ROOT_DIR="${SCRIPT_DIR}/.."
cd "${ROOT_DIR}"

# Run the SG-Nav
python SG_Nav.py --visualize