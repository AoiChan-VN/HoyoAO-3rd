class_name AppLogger
extends RefCounted

enum Level { TRACE, DEBUG, INFO, WARNING, ERROR, FATAL }

var _min_level: Level = Level.INFO

func set_min_level(level: Level) -> void:
    _min_level = level

func trace(category: String, message: String) -> void:
    _write(Level.TRACE, category, message)

func debug(category: String, message: String) -> void:
    _write(Level.DEBUG, category, message)

func info(category: String, message: String) -> void:
    _write(Level.INFO, category, message)

func warning(category: String, message: String) -> void:
    _write(Level.WARNING, category, message)

func error(category: String, message: String) -> void:
    _write(Level.ERROR, category, message)

func fatal(category: String, message: String) -> void:
    _write(Level.FATAL, category, message)

func _write(level: Level, category: String, message: String) -> void:
    if level < _min_level:
        return

    var line: String = "%s [%s] [%s] %s" % [
        _timestamp(),
        _level_name(level),
        category,
        message
    ]

    match level:
        Level.WARNING:
            push_warning(line)
        Level.ERROR, Level.FATAL:
            push_error(line)
        _:
            print(line)

func _timestamp() -> String:
    var t: Dictionary = Time.get_datetime_dict_from_system()
    var hour := _get_int(t, "hour", 0)
    var minute := _get_int(t, "minute", 0)
    var second := _get_int(t, "second", 0)
    var millisecond := _get_int(t, "millisecond", int(Time.get_ticks_msec() % 1000))
    return "%02d:%02d:%02d.%03d" % [hour, minute, second, millisecond]

func _get_int(dict: Dictionary, key: String, fallback: int) -> int:
    if dict.has(key):
        return int(dict[key])
    return fallback

func _level_name(level: Level) -> String:
    match level:
        Level.TRACE:
            return "TRACE"
        Level.DEBUG:
            return "DEBUG"
        Level.INFO:
            return "INFO"
        Level.WARNING:
            return "WARNING"
        Level.ERROR:
            return "ERROR"
        Level.FATAL:
            return "FATAL"
    return "UNKNOWN" 
