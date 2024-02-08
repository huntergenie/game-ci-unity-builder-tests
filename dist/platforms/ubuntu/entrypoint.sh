#!/usr/bin/env bash

#
# Create directory for license activation
#

ACTIVATE_LICENSE_PATH="$GITHUB_WORKSPACE/_activate-license~"
mkdir -p "$ACTIVATE_LICENSE_PATH"

#
# Run steps
#
source /steps/set_extra_git_configs.sh
source /steps/set_gitcredential.sh
source /steps/activate.sh
echo "hunter installing libs"

apt-get update && apt-get install -y \
    libx11-dev \
    libxxf86vm-dev \
    libxcursor-dev \
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libegl-dev \
    libwayland-dev \
    wayland-protocols \
    libxkbcommon-dev \
    libdbus-1-dev \
    libsm-dev

export LD_LIBRARY_PATH = /usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
echo "LD_Lib_path: "
echo $LD_LIBRARY_PATH

echo "hunter installing pip"
apt update --yes && apt install --yes python3-pip

echo "hunter installing wheel"
pip3 install --no-input https://d1v5e8dxjkq76c.cloudfront.net/genies-validation/genies_validation-0.0.1-py3-none-any.whl

echo "hunter running py script"
python3 -c "import bpy;"

echo "hunter import done running build"

source /steps/build.sh
source /steps/return_license.sh

#
# Remove license activation directory
#

rm -r "$ACTIVATE_LICENSE_PATH"

#
# Instructions for debugging
#

if [[ $BUILD_EXIT_CODE -gt 0 ]]; then
echo ""
echo "###########################"
echo "#         Failure         #"
echo "###########################"
echo ""
echo "Please note that the exit code is not very descriptive."
echo "Most likely it will not help you solve the issue."
echo ""
echo "To find the reason for failure: please search for errors in the log above."
echo ""
fi;

#
# Exit with code from the build step.
#

exit $BUILD_EXIT_CODE
