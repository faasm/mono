#!/bin/bash
set -e

THIS_DIR=$(dirname $(readlink -f $0))
PROJ_ROOT=${THIS_DIR}/..

pushd ${PROJ_ROOT} > /dev/null

if [[ -z "$1" ]]; then
    echo "Must specify which CLI"
    exit 1
elif [[ "$1" == "faasm" ]]; then
    MODE="faasm"
    CLI_CONTAINER="faasm-cli"
elif [[ "$1" == "cpp" ]]; then
    MODE="cpp"
    CLI_CONTAINER="cpp-cli"
elif [[ "$1" == "python" ]]; then
    MODE="python"
    CLI_CONTAINER="python-cli"
else
    echo "Unrecognised CLI. Must be one of faasm, cpp or python"
    exit 1
fi

FAASM_VERSION=$(cat faasm/VERSION)
CPP_VERSION=$(cat cpp/VERSION)
PYTHON_VERSION=$(cat python/VERSION)

if [[ -z "$CLI_IMAGE" ]]; then
    CLI_IMAGE=faasm/cli:${FAASM_VERSION}
fi
if [[ -z "$SYSROOT_CLI_IMAGE" ]]; then
    SYSROOT_CLI_IMAGE=faasm/cpp-sysroot:${CPP_VERSION}
fi
if [[ -z "$CPYTHON_CLI_IMAGE" ]]; then
    CPYTHON_CLI_IMAGE=faasm/cpython:${PYTHON_VERSION}
fi

INNER_SHELL=${SHELL:-"/bin/bash"}

echo "Running ${CLI_CONTAINER}"

# Make sure the CLI is running already in the background (avoids creating a new
# container every time)
docker-compose \
    up \
    --no-recreate \
    -d \
    ${CLI_CONTAINER}    

# Attach to the CLI container
docker-compose \
    exec \
    ${CLI_CONTAINER} \
    ${INNER_SHELL}

popd > /dev/null
