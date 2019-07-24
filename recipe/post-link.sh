#!/bin/bash

if [[ "$PKG_NAME" == "conda-wrappers" ]]; then
    # It is a conda build environment or it is being installed with
    # "conda install -n env_name conda-wrappers"
    ENV_DIR="$PREFIX"
elif [[ ! -z "$CONDA_PREFIX" ]]; then
    # regular env on newer conda versions
    ENV_DIR="$CONDA_PREFIX"
elif [[ ! -z "$CONDA_ENV_PATH" ]]; then
    # variable that is set on older conda versions
    ENV_DIR="$CONDA_ENV_PATH"
elif [[ ! -z "$CONDA_DEFAULT_ENV" ]]; then
    # variable that is set on older conda versions
    ENV_DIR="$CONDA_DEFAULT_ENV"
else
    ENV_DIR="`conda info --root`"
    echo ''
    echo 'None of CONDA_PREFIX, CONDA_DEFAULT_ENV, CONDA_ENV_PATH are set. Assuming conda root env' >> "$ENV_DIR/.messages.txt"
fi

CREATE_WRAPPERS_COMMAND="$ENV_DIR/bin/create-wrappers"

BIN_DIR="$ENV_DIR/bin"
WRAPPERS_DIR="$BIN_DIR/wrappers/conda"

echo "Creating wrappers from $BIN_DIR to $WRAPPERS_DIR" >> "$ENV_DIR/.messages.txt"
"$CREATE_WRAPPERS_COMMAND" \
    -t conda \
    --use-exec \
    -b "$BIN_DIR" \
    -d "$WRAPPERS_DIR" \
    --conda-env-dir "$ENV_DIR"
