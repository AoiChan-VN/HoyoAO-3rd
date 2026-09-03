class_name FileVersionService
extends IVersionService

const CONFIG_PATH: String = "res://App/Config/app.cfg"

var _loaded: bool = false
var _version: String = ""

func _init() -> void:
    var config := ConfigFile.new()
    var err: Error = config.load(CONFIG_PATH)

    if err == OK:
        _loaded = true
        _version = str(config.get_value("app", "version", ""))

func is_version_valid() -> bool:
    return _loaded and _is_semver(_version)

func get_version() -> String:
    return _version

func _is_semver(value: String) -> bool:
    var parts: PackedStringArray = value.split(".")

    if parts.size() != 3:
        return false

    for part in parts:
        if part.is_empty():
            return false

        if not part.is_valid_int():
            return false

    return true 
