class_name NetworkGate
extends Node

signal state_changed(new_state: NetworkState.State)
signal gate_passed()
signal gate_blocked()

var _connectivity_service: IConnectivityService
var _current_state: NetworkState.State = NetworkState.State.UNKNOWN

func _ready() -> void:
    _connectivity_service = ConnectivityServiceImpl.new()
    add_child(_connectivity_service)
    _connectivity_service.connectivity_changed.connect(_on_connectivity_changed)
    _connectivity_service.check_connectivity()

func _on_connectivity_changed(new_state: NetworkState.State) -> void:
    _current_state = new_state
    state_changed.emit(_current_state)

    match _current_state:
        NetworkState.State.VALIDATED:
            gate_passed.emit()
        _:
            gate_blocked.emit()

func get_current_state() -> NetworkState.State:
    return _current_state
