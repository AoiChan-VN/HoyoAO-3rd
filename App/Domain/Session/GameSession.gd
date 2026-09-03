class_name GameSession
extends RefCounted

var session_id: String = ""
var player_character_id: StringName = &""
var is_active: bool = false
var start_time_unix: int = 0

func _init(p_session_id: String, p_character_id: StringName) -> void:
    session_id = p_session_id
    player_character_id = p_character_id
    is_active = true
    start_time_unix = Time.get_unix_time_from_system()

func end_session() -> void:
    is_active = false 
