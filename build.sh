#!/bin/bash

set -e

DUMP=$1

MIUICAMERA_SRC=product/priv-app/MiuiCamera/MiuiCamera.apk
MIUICAMERA_OUT=miuicamera.zip

REQUIRED_FILES=$(cat << EOF
$MIUICAMERA_SRC
EOF
)

colored_echo() {
    # Define color codes
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    # Choose color based on the first argument
    case "$1" in
        red)    COLOR=$RED ;;
        green)  COLOR=$GREEN ;;
        yellow) COLOR=$YELLOW ;;
        blue)   COLOR=$BLUE ;;
        *)      COLOR=$NC ;; # Default to no color
    esac

    # Print the message with the selected color
    shift
    echo -e "${COLOR}$*${NC}"
}

usage() {
    echo "Usage: $0 <path-to-system-dump>"
    exit
}

get_file() {
    echo $DUMP/$1
}

check_file() {
    if [[ -f $(get_file $1) ]]; then
        return 0
    else
        return 1
    fi
}

copy_template() {
    rm -rf out
    cp -r template out
}

build_stage() {
    local section="$@"
    local length=${#section}
    local divider=$(printf '%*s' "$length" '' | tr ' ' '=')

    colored_echo blue "$divider"
    colored_echo blue "$section"
    colored_echo blue "$divider"
}

if [[ -z $DUMP ]] || [[ ! -d $DUMP ]]; then
    usage
fi

#
# Check for required files
#
build_stage "Checking required files"

for file in $REQUIRED_FILES; do
    if ! check_file $file ; then
        colored_echo red "$file does not exist in the given dump"
        exit 1
    else
        colored_echo green "$file found"
    fi
done

#
# Copy the template module
#
build_stage "Copying the module template"

copy_template

# Decompile the apk
build_stage "Decompile the apk"
tmp_dir=.tmp
rm -rf $tmp_dir
apktool d -f $(get_file $MIUICAMERA_SRC) -o $tmp_dir

# Patch the apk
build_stage "Patching the apk"
for p in $(find patches -name "*.patch"); do
    patch -p1 -d $tmp_dir < $p
done

# Build the apk
build_stage "Building the apk"
apktool b $tmp_dir -o $tmp_dir/unsigned.apk

# Sign the apk
build_stage "Signing the apk"
zipalign 4 $tmp_dir/unsigned.apk $tmp_dir/aligned.apk
apksigner sign --key keys/testkey.pk8 --cert keys/testkey.x509.pem --in $tmp_dir/aligned.apk --out $tmp_dir/signed.apk
mv $tmp_dir/signed.apk out/system/priv-app/MiuiCamera/MiuiCamera.apk

# Build the module
build_stage "Building the module"
rm -f ../$MIUICAMERA_OUT
(cd out && zip -r ../$MIUICAMERA_OUT *)

rm -rf out
rm -rf $tmp_dir

build_stage "Module generated at $MIUICAMERA_OUT"
