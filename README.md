# proprietary_vendor_xiaomi_socrates-camera

Prebuilt MIUI Camera to include in custom ROM builds.

### Supported devices
* Redmi K60 Pro (socrates)

### How to use?

1. Clone this repo to `vendor/xiaomi/socrates-camera`

2. Inherit it from `device.mk` in device tree:

```
# Camera
$(call inherit-product-if-exists, vendor/xiaomi/socrates-camera/miuicamera.mk)
```
