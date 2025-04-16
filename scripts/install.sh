#!/bin/bash -e

# Get the directory of this script.
# Reference: https://stackoverflow.com/q/59895
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
ORIGINAL_DIR="$(pwd)"

# Build the GLIP
GLIP_DIR="${SCRIPT_DIR}/../GLIP"
cd "${GLIP_DIR}"
rm -rf build
python setup.py build develop --user

# Install GroundingDINO
# NOTE: This package need to be installed with GPU, don't install it inside the dockerfile.
# Otherwise, it will only install the CPU dependencies.
GROUNDING_DINO_DIR="${SCRIPT_DIR}/../docker/GroundingDINO"
cd "${GROUNDING_DINO_DIR}"
export CUDA_HOME=/usr/local/cuda-11.1
pip3 install --no-build-isolation -e .

# Install agent into habitat-sim
HABITAT_SIM_PATH=$(pip3 show habitat_sim | grep 'Location:' | awk '{print $2}')
cd "${SCRIPT_DIR}/.."
cp tools/agent.py ${HABITAT_SIM_PATH}/habitat_sim/agent/

cd "${ORIGINAL_DIR}"
echo "Finished!"