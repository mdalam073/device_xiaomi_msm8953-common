LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := \
    AndroidAutoStubPrebuilt \
    AmbientSensePrebuilt \
    CalendarGooglePrebuilt \
    Camera2 \
    Chrome-Stub \
    Drive \
    Eleven \
    Etar \
    ExactCalculator \
    Gallery2 \
    Jelly \
    MatLog \
    Maps \
    Gmail2 \
    PersonalSafety \
    Photos \
    PrebuiltDeskClockGoogle \
    Recorder \
    RecorderPrebuilt \
    SafetyHubPrebuilt \
    Snap \
    TipsPrebuilt \
    Velvet \
    YouTube \
    Gboard \
    Wellbeing \
    Pixel-exclusive features \
    PlayMusic \
    GoogleKeep \
    PlayAutoInstallConfig \
    AOSPBrowser \
    Email \
    FMRadio

LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := platform
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)
