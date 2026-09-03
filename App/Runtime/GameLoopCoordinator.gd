class_name GameLoopCoordinator
extends Node

signal game_world_load_requested(character_id: StringName)
signal game_world_unload_requested()

@export var app_flow_path: NodePath
@export var default_character_id: StringName = &"player_base"

var _app_flow: AppFlowCoordinator
var _session_service: ISessionService
var _is_world_loaded: bool = false

func _ready() -> void:
    _app_flow = get_node_or_null(app_flow_path) as AppFlowCoordinator
    if _app_flow == null:
        push_error("GameLoopCoordinator: AppFlowCoordinator is missing.")
        return
        
    _session_service = LocalSessionServiceImpl.new()
    
    _app_flow.flow_ready.connect(_on_flow_ready)
    _app_flow.flow_blocked.connect(_on_flow_blocked)
    
func _on_flow_ready() -> void:
    if _is_world_loaded:
        return
        
    var session: GameSession = _session_service.start_session(default_character_id)
    if session != null:
        _is_world_loaded = true
        game_world_load_requested.emit(session.player_character_id)

func _on_flow_blocked(_message: String) -> void:
    if not _is_world_loaded:
        return
        
    _session_service.end_current_session()
    _is_world_loaded = false
    game_world_unload_requested.emit()

func get_session_service() -> ISessionService:
    return _session_service 
