#
# Copyright (C) 2018 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# define hardware platform
PRODUCT_PLATFORM := sm8150

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

include device/google/coral/device.mk

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = 2022-10-05

# Set boot SPL
BOOT_SECURITY_PATCH = 2022-10-05

PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.offload.buffer.size.kb=256

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# A2DP offload enabled for compilation
AUDIO_FEATURE_ENABLED_A2DP_OFFLOAD := true

# A2DP offload supported
PRODUCT_PROPERTY_OVERRIDES += \
ro.bluetooth.a2dp_offload.supported=true

# A2DP offload disabled (UI toggle property)
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.disabled=false

# A2DP offload DSP supported encoder list
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Enable AAC frame ctl for A2DP sinks
PRODUCT_PROPERTY_OVERRIDES += \
persist.vendor.bt.aac_frm_ctl.enabled=true

# Set lmkd options
PRODUCT_PRODUCT_PROPERTIES += \
	ro.config.low_ram = false \
	ro.lmk.log_stats = false \

# Modem logging file
PRODUCT_COPY_FILES += \
    device/google/coral/init.logging.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_PLATFORM).logging.rc

PRODUCT_COPY_FILES += \
    device/google/coral/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Pixelstats broken mic detection
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.mic_break=true

# Enable APK Verity, which depends on fs-verity support in kernel.
PRODUCT_PROPERTY_OVERRIDES += ro.apk_verity.mode=2

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_wide_color_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.has_HDR_display=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_idle_timer_ms=80
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_touch_timer_ms=200
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.set_display_power_timer_ms=1000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.support_kernel_idle_timer=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_content_detection_for_refresh_rate=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

# Must align with HAL types Dataspace
# The data space of wide color gamut composition preference is Dataspace::DISPLAY_P3
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.wcg_composition_dataspace=143261696

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio low latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

# Set thermal warm reset
PRODUCT_PRODUCT_PROPERTIES += \
    ro.thermal_warmreset = true \

# Enable Incremental on the device via kernel module
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=module:/vendor/lib/modules/incrementalfs.ko

PRODUCT_ENFORCE_PRODUCT_PARTITION_INTERFACE := true

