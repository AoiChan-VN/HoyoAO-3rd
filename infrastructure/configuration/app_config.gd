class_name AppConfig
extends RefCounted

var app_version: String = "0.1.0"
var environment: String = "development"
var log_level: String = "debug"

func load_from_file(path: String) -> bool:
    if not FileAccess.file_exists(path):
        return false

    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return false

    var text := file.get_as_text()
    file.close()

    var json := JSON.new()
    if json.parse(text) != OK:
        return false

    var data: Variant = json.get_data()
    if typeof(data) != TYPE_DICTIONARY:
        return false

    var dict: Dictionary = data
    app_version = _read_string(dict, "app_version", app_version)
    environment = _read_string(dict, "environment", environment)
    log_level = _read_string(dict, "log_level", log_level)
    return true

func _read_string(dict: Dictionary, key: String, fallback: String) -> String:
    if dict.has(key):
        var value: Variant = dict[key]
        if typeof(value) == TYPE_STRING:
            var s: String = value
            if not s.is_empty():
                return s
    return fallback 
