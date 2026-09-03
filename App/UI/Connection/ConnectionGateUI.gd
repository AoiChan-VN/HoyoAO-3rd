class_name ConnectionGateUI
extends Control

@export var gate_path: NodePath
@export var background_path: NodePath
@export var status_label_path: NodePath

var _gate: NetworkGate
var _background: Control
var _status_label: Label

func _ready() -> void:
    _gate = get_node_or_null(gate_path) as NetworkGate
    _background = get_node_or_null(background_path) as Control
    _status_label = get_node_or_null(status_label_path) as Label

    if _gate == null:
        push_error("ConnectionGateUI: NetworkGate is missing.")
        return

    if _background == null:
        push_error("ConnectionGateUI: Background is missing.")
        return

    if _status_label == null:
        push_error("ConnectionGateUI: StatusLabel is missing.")
        return

    _gate.state_changed.connect(_on_gate_state_changed)
    _render(_gate.get_current_state())

func _on_gate_state_changed(new_state: NetworkState.State) -> void:
    _render(new_state)

func _render(state: NetworkState.State) -> void:
    var validated: bool = state == NetworkState.State.VALIDATED

    visible = true
    _background.visible = not validated

    if validated:
        mouse_filter = Control.MOUSE_FILTER_IGNORE
    else:
        mouse_filter = Control.MOUSE_FILTER_STOP

    _status_label.text = _get_status_text(state)

func _get_status_text(state: NetworkState.State) -> String:
    match state:
        NetworkState.State.UNKNOWN:
            return "Đang kiểm tra kết nối..."
        NetworkState.State.CHECKING:
            return "Đang kiểm tra kết nối..."
        NetworkState.State.AVAILABLE:
            return "Đang xác thực kết nối..."
        NetworkState.State.BLOCKED:
            return "Không có kết nối Internet."
        NetworkState.State.RECOVERING:
            return "Mất kết nối, đang thử lại..."
        NetworkState.State.VALIDATED:
            return "Kết nối hợp lệ."

    return "Lỗi kết nối không xác định." 
