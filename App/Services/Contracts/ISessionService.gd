class_name ISessionService
extends RefCounted

signal session_started(session: GameSession)
signal session_ended(session: GameSession)

func start_session(character_id: StringName) -> GameSession:
    push_error("ISessionService.start_session() not implemented.")
    return null

func end_current_session() -> void:
    push_error("ISessionService.end_current_session() not implemented.")

func get_current_session() -> GameSession:
    push_error("ISessionService.get_current_session() not implemented.")
    return null 
