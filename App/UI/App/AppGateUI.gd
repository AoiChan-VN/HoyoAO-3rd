class_name AppGateUI
extends Control

@export var flow_path: NodePath
@export var background_path: NodePath
@export var status_label_path: NodePath

var _flow: AppFlowCoordinator
var _background: Control
var _status_label: Label

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false

    _flow = get_node_or_null(flow_path) as AppFlowCoordinator
    _background = get_node_or_null(background_path) as Control
    _status_label = get_node_or_null(status_label_path) as Label

    if _flow == null:
        push_error("AppGateUI: AppFlowCoordinator is missing.")
        return

    if _background == null:
        push_error("AppGateUI: Background is missing.")
        return

    if _status_label == null:
        push_error("AppGateUI: StatusLabel is missing.")
        return

    _flow.flow_state_changed.connect(_on_flow_state_changed)
    _render(_flow.get_current_state(), _flow.get_current_message())

func _on_flow_state_changed(state: int, message: String) -> void:
    _render(state, message)

func _render(state: int, message: String) -> void:
    var ready: bool = state == AppFlowState.State.READY

    visible = not ready
    _background.visible = not ready

    if ready:
        mouse_filter = Control.MOUSE_FILTER_IGNORE
    else:
        mouse_filter = Control.MOUSE_FILTER_STOP

    _status_label.text = message 
