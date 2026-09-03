class_name AppFlowCoordinator
extends Node

signal flow_state_changed(state: int, message: String)
signal flow_ready()
signal flow_blocked(message: String)

@export var network_gate_path: NodePath

var _network_gate: NetworkGate
var _platform_service: IPlatformService
var _version_service: IVersionService

var _current_state: int = AppFlowState.State.BOOT
var _current_message: String = ""
var _permanent_failure: bool = false

func _ready() -> void:
    _network_gate = get_node_or_null(network_gate_path) as NetworkGate

    if _network_gate == null:
        push_error("AppFlowCoordinator: NetworkGate is missing.")
        return

    _platform_service = PlatformServiceImpl.new()
    _version_service = FileVersionService.new()

    _network_gate.state_changed.connect(_on_network_state_changed)
    _run()

func get_current_state() -> int:
    return _current_state

func get_current_message() -> String:
    return _current_message

func _run() -> void:
    _set_state(AppFlowState.State.PLATFORM_CHECK, "Đang kiểm tra nền tảng...")

    if not _platform_service.is_supported():
        _block_permanently("Nền tảng không được hỗ trợ: " + _platform_service.get_platform_name())
        return

    _set_state(AppFlowState.State.NETWORK_CHECK, "Đang kiểm tra kết nối...")

    if _network_gate.get_current_state() == NetworkState.State.VALIDATED:
        _check_version()

func _on_network_state_changed(new_state: NetworkState.State) -> void:
    if _permanent_failure:
        return

    if new_state == NetworkState.State.VALIDATED:
        if _current_state == AppFlowState.State.NETWORK_CHECK:
            _check_version()
        return

    if _current_state == AppFlowState.State.VERSION_CHECK or _current_state == AppFlowState.State.READY:
        _set_state(AppFlowState.State.NETWORK_CHECK, "Mất kết nối, đang kiểm tra lại...")
    elif _current_state == AppFlowState.State.NETWORK_CHECK:
        _set_state(AppFlowState.State.NETWORK_CHECK, "Đang kiểm tra kết nối...")

func _check_version() -> void:
    _set_state(AppFlowState.State.VERSION_CHECK, "Đang kiểm tra phiên bản...")

    if not _version_service.is_version_valid():
        _block_permanently("Phiên bản không hợp lệ: " + _version_service.get_version())
        return

    _set_state(AppFlowState.State.READY, "Sẵn sàng")
    flow_ready.emit()

func _set_state(state: int, message: String) -> void:
    _current_state = state
    _current_message = message
    flow_state_changed.emit(_current_state, _current_message)

func _block_permanently(message: String) -> void:
    _permanent_failure = true
    _set_state(AppFlowState.State.BLOCKED, message)
    flow_blocked.emit(message) 
