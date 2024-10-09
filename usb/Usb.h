#ifndef ANDROID_HARDWARE_USB_V1_0_USB_H
#define ANDROID_HARDWARE_USB_V1_0_USB_H

#include <android/hardware/usb/1.0/IUsb.h>
#include <hidl/MQDescriptor.h>
#include <hidl/Status.h>
#include <utils/Log.h>

#ifdef LOG_TAG
#undef LOG_TAG
#endif

#define LOG_TAG "android.hardware.usb@1.3-service.msm8953"
#define UEVENT_MSG_LEN 2048

namespace android {
namespace hardware {
namespace usb {
namespace V1_3 {
namespace implementation {

using ::android::hardware::usb::V1_3::IUsb;
using ::android::hardware::usb::V1_3::IUsbCallback;
using ::android::hardware::usb::V1_3::PortRole;
using ::android::hidl::base::V1_0::IBase;
using ::android::hardware::hidl_array;
using ::android::hardware::hidl_memory;
using ::android::hardware::hidl_string;
using ::android::hardware::hidl_vec;
using ::android::hardware::Return;
using ::android::hardware::Void;
using ::android::sp;

struct Usb : public IUsb {
    Return<void> switchRole(const hidl_string& portName, const PortRole& role) override;
    Return<void> setCallback(const sp<IUsbCallback>& callback) override;
    Return<void> queryPortStatus() override;

    sp<IUsbCallback> mCallback;
    pthread_mutex_t mLock = PTHREAD_MUTEX_INITIALIZER;
};

}  // namespace implementation
}  // namespace V1_3
}  // namespace usb
}  // namespace hardware
}  // namespace android

#endif  // ANDROID_HARDWARE_USB_V1_0_USB_H
