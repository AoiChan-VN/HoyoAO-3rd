class_name LocalSessionServiceImpl
extends ISessionService

var _current_session: GameSession = null

func start_session(character_id: StringName) -> GameSession:
    if _current_session != null and _current_session.is_active:
        end_current_session()
        
    var new_id: String = str(Time.get_unix_time_from_system()) + "_" + str(randi())
    _current_session = GameSession.new(new_id, character_id)
    session_started.emit(_current_session)
    return _current_session

func end_current_session() -> void:
    if _current_session != null and _current_session.is_active:
        _current_session.end_session()
        session_ended.emit(_current_session)
        _current_session = null

func get_current_session() -> GameSession:
    return _current_session 
