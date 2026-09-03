class_name PlatformServiceImpl
extends IPlatformService

const SUPPORTED_PLATFORMS: PackedStringArray = [
    "Android",
    "Windows",
    "macOS",
    "Linux"
]

func is_supported() -> bool:
    return SUPPORTED_PLATFORMS.has(OS.get_name())

func get_platform_name() -> String:
    return OS.get_name() 
