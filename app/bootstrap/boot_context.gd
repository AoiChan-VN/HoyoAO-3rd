class_name BootContext
extends RefCounted

var boot_session_id: String
var started_unix_msec: int
var app_version: String
var platform_name: String
var configuration_loaded := false
var diagnostics_ready := false
var runtime_ready := false
var failure_message := ""

func _init() -> void:
    started_unix_msec = int(Time.get_unix_time_from_system() * 1000.0)
    platform_name = OS.get_name()
    boot_session_id = "%d-%d" % [
        started_unix_msec,
        int(Time.get_ticks_msec())
    ]
