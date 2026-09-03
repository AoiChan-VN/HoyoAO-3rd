class_name IPlatformService
extends RefCounted

func is_supported() -> bool:
    push_error("IPlatformService.is_supported() not implemented.")
    return false

func get_platform_name() -> String:
    push_error("IPlatformService.get_platform_name() not implemented.")
    return "" 
