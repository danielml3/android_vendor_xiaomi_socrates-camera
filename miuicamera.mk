#
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

CAMERA_PACKAGE_NAME := com.android.camera

# Overlays
PRODUCT_PACKAGES += \
    MiuiCameraOverlayIcon \
    MiuiCameraOverlayLeicaed

# Permissions
PRODUCT_COPY_FILES += \
    vendor/xiaomi/socrates-camera/configs/permissions/default-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-permissions-miuicamera.xml \
    vendor/xiaomi/socrates-camera/configs/permissions/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml \
    vendor/xiaomi/socrates-camera/configs/permissions/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-miuicamera.xml

# Properties
TARGET_SYSTEM_PROP += vendor/xiaomi/socrates-camera/configs/properties/system.prop

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/xiaomi/socrates-camera/sepolicy/vendor

$(call inherit-product, vendor/xiaomi/socrates-camera/camera-vendor.mk)
