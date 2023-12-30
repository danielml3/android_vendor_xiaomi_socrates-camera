#
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

# Overlays
PRODUCT_PACKAGES += \
    MiuiCameraOverlayIcon \
    MiuiCameraOverlayLeicaed

# Permissions
PRODUCT_COPY_FILES += \
    vendor/xiaomi/camera/configs/permissions/default-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-permissions-miuicamera.xml \
    vendor/xiaomi/camera/configs/permissions/miuicamera-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/miuicamera-hiddenapi-package-whitelist.xml \
    vendor/xiaomi/camera/configs/permissions/privapp-permissions-miuicamera.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-miuicamera.xml

# Properties
TARGET_SYSTEM_PROP += vendor/xiaomi/camera/configs/properties/system.prop
PRODUCT_COPY_FILES += \
    vendor/xiaomi/camera/configs/properties/system_camera_fuxi.prop:$(TARGET_COPY_OUT_SYSTEM)/etc/build_camera_fuxi.prop \
    vendor/xiaomi/camera/configs/properties/system_camera_nuwa.prop:$(TARGET_COPY_OUT_SYSTEM)/etc/build_camera_nuwa.prop

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/xiaomi/camera/sepolicy/vendor

$(call inherit-product, vendor/xiaomi/camera/camera-vendor.mk)
