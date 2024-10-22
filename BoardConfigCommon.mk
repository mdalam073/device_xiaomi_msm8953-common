#
# Copyright (C) 2017-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/xiaomi/msm8953-common

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Build
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_hsl_uart,0x78af000
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += loop.max_part=7
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/7824900.sdhci
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_KERNEL_PAGESIZE :=  2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100
TARGET_KERNEL_SOURCE := kernel/xiaomi/msm8953
TARGET_KERNEL_LLVM_BINUTILS := true
BOARD_KERNEL_CMDLINE += androidboot.usbconfigfs=true

# ANT
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Audio
AUDIO_FEATURE_ENABLED_ANC_HEADSET := true
AUDIO_FEATURE_ENABLED_ALAC_OFFLOAD := true
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_CUSTOMSTEREO := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
AUDIO_FEATURE_ENABLED_FLAC_OFFLOAD := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_HFP := true
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24 := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SOURCE_TRACKING := true
AUDIO_FEATURE_ENABLED_EXT_AMPLIFIER := false
AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8953
TARGET_NO_BOOTLOADER := true

# Camera
USE_DEVICE_SPECIFIC_CAMERA := true
TARGET_USES_QTI_CAMERA_DEVICE := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
MALLOC_SVELTE_FOR_LIBC32 := true

# Display
TARGET_USES_ION := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_HWC2 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# FM
BOARD_HAVE_QCOM_FM := true
TARGET_QCOM_NO_FM_FIRMWARE := true

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
LOC_HIDL_VERSION := 3.0

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(COMMON_PATH)/framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix_legacy.xml \
    vendor/aosp/config/device_framework_matrix.xml
DEVICE_MANIFEST_FILE := $(COMMON_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(COMMON_PATH)/compatibility_matrix.xml

# Init
TARGET_INIT_VENDOR_LIB := //$(COMMON_PATH):libinit_msm8953
TARGET_RECOVERY_DEVICE_MODULES := libinit_msm8953

# Lineage Health
TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS := false

# Partitions
# Add rule for super_empty.img creation
INSTALLED_SUPERIMAGE_EMPTY_TARGET := $(PRODUCT_OUT)/super_empty.img

$(INSTALLED_SUPERIMAGE_EMPTY_TARGET): $(INSTALLED_SUPERIMAGE_TARGET)
	@echo "Creating super_empty.img"
	cp $(INSTALLED_SUPERIMAGE_TARGET) $(INSTALLED_SUPERIMAGE_EMPTY_TARGET)

# Rule to create dummy image based on super_empty.img if needed
INSTALLED_SUPERIMAGE_DUMMY_TARGET := $(PRODUCT_OUT)/super_dummy.img

$(INSTALLED_SUPERIMAGE_DUMMY_TARGET): $(INSTALLED_SUPERIMAGE_EMPTY_TARGET)
	@echo "Creating super_dummy.img from super_empty.img"
	cp $(INSTALLED_SUPERIMAGE_EMPTY_TARGET) $(INSTALLED_SUPERIMAGE_DUMMY_TARGET)

# Ensure the build system knows these targets
.PHONY: super_emptyimage super_dummyimage
super_emptyimage: $(INSTALLED_SUPERIMAGE_EMPTY_TARGET)
super_dummyimage: $(INSTALLED_SUPERIMAGE_DUMMY_TARGET)

# Add these to final images
INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_SUPERIMAGE_DUMMY_TARGET)

# Flash block size and partition sizes
BOARD_FLASH_BLOCK_SIZE := 131072 # 128 KB block size
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864 # 64 MB Boot image size
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864 # 64 MB Recovery image size
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456 # 256 MB Cache image size

# Use ext4 and f2fs for user images
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Core and additional partitions
CORE_PARTITIONS := system vendor
ADDITIONAL_PARTITIONS := odm product system_ext
ALL_PARTITIONS := $(CORE_PARTITIONS) $(ADDITIONAL_PARTITIONS)

# Set filesystem type for all partitions to ext4
$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Dynamic partitioning setup
BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor
BOARD_USES_METADATA_PARTITION := true
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_SIZE := 5368709120  # 5 GB Super partition

# Adjust sizes for system and vendor partitions inside the super partition
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3221225472 # 3 GB System partition size
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 2147483648 # 2 GB Vendor partition size

# Dynamic partition groups and sizes
BOARD_SUPER_PARTITION_GROUPS := tissot_dynamic_partitions
BOARD_TISSOT_DYNAMIC_PARTITIONS_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304) # Reserve 4MB
BOARD_TISSOT_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor

# Reserved sizes for system, vendor, product, etc.
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 20971520 # 20 MB reserved for system image
BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 20971520 # 20 MB reserved for system_ext image
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 20971520 # 20 MB reserved for product image
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 20971520 # 20 MB reserved for vendor image
BOARD_ODMIMAGE_PARTITION_RESERVED_SIZE := 20971520 # 20 MB reserved for ODM image

# Super image config
INSTALLED_SUPERIMAGE_TARGET := $(PRODUCT_OUT)/super.img
INSTALLED_SUPERIMAGE_EMPTY_TARGET := $(PRODUCT_OUT)/super_empty.img

# Extra symlinks for specific mount points
BOARD_ROOT_EXTRA_SYMLINKS := \
    /vendor/dsp:/dsp \
    /vendor/firmware_mnt:/firmware \
    /vendor/bt_firmware:/bt_firmware \
    /mnt/vendor/persist:/persist

# Power
TARGET_USES_INTERACTION_BOOST := true

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := msm8953

# Properties
TARGET_ODM_PROP += $(COMMON_PATH)/odm.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
TARGET_SYSTEM_EXT_PROP += $(COMMON_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor.prop

# Recovery
ifeq ($(AB_OTA_UPDATER), true)
    ifeq ($(TARGET_IS_LEGACY), true)
        TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab_legacy_AB.qcom
    else
        TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab_AB.qcom
    endif
else ifeq ($(TARGET_IS_LEGACY), true)
    TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab_legacy.qcom
else
    TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab.qcom
endif
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# SELinux
include device/qcom/sepolicy-legacy-um/SEPolicy.mk
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor
PRODUCT_PRIVATE_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/private

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_VNDK_VERSION := current
NEED_AIDL_NDK_PLATFORM_BACKEND := true

# Wi-Fi
BOARD_HAS_QCOM_WLAN := true
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
TARGET_HAS_BROKEN_WLAN_SET_INTERFACE := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_AVOID_IFACE_RESET_MAC_CHANGE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Inherit from the proprietary version
include vendor/xiaomi/msm8953-common/BoardConfigVendor.mk
