class_name InputService
extends Node

signal action_pressed(action_id: int)
signal action_released(action_id: int)
signal move_axis_changed(axis: Vector2)
signal look_axis_changed(axis: Vector2)
signal state_updated(state: InputFrameState)

var _state: InputFrameState = InputFrameState.new()
var _held_actions: PackedInt32Array = PackedInt32Array()

func get_state() -> InputFrameState:
    return _state

func is_action_held(action_id: int) -> bool:
    return _state.is_held(action_id)

func press_action(action_id: int) -> void:
    if _state.is_held(action_id):
        return

    _state.set_held(action_id, true)
    _held_actions.append(action_id)

    action_pressed.emit(action_id)
    state_updated.emit(_state)

func release_action(action_id: int) -> void:
    if not _state.is_held(action_id):
        return

    _state.set_held(action_id, false)

    var index: int = _held_actions.find(action_id)
    if index != -1:
        _held_actions.remove_at(index)

    action_released.emit(action_id)
    state_updated.emit(_state)

func trigger_action(action_id: int) -> void:
    action_pressed.emit(action_id)
    action_released.emit(action_id)

func set_move_axis(axis: Vector2) -> void:
    var limited: Vector2 = axis.limit_length(1.0)
    if _state.move_axis == limited:
        return

    _state.move_axis = limited
    move_axis_changed.emit(limited)
    state_updated.emit(_state)

func set_look_axis(axis: Vector2) -> void:
    var limited: Vector2 = axis.limit_length(1.0)
    if _state.look_axis == limited:
        return

    _state.look_axis = limited
    look_axis_changed.emit(limited)
    state_updated.emit(_state)

func reset() -> void:
    var copy: PackedInt32Array = _held_actions.duplicate()
    for action_id in copy:
        release_action(action_id)

    set_move_axis(Vector2.ZERO)
    set_look_axis(Vector2.ZERO) 
