#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=socrates-camera
DEVICE_COMMON=socrates-camera
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true

# Warning headers and guards
write_headers "socrates"
sed -i 's|device/|vendor/|g' "$ANDROIDBP" "$ANDROIDMK" "$BOARDMK" "$PRODUCTMK"

cat << 'EOF' >> "$ANDROIDMK"
CAMERA_LIBRARIES := libcamera_algoup_jni.xiaomi.so libcamera_mianode_jni.xiaomi.so

CAMERA_SYMLINKS := $(addprefix $(TARGET_OUT_APPS_PRIVILEGED)/MiuiCamera/lib/arm64/,$(notdir $(CAMERA_LIBRARIES)))
$(CAMERA_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "MiuiCamera lib link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /system/lib64/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(CAMERA_SYMLINKS)

EOF

write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Finish
write_footers
