class_name InputFrameState
extends RefCounted

var move_axis: Vector2 = Vector2.ZERO
var look_axis: Vector2 = Vector2.ZERO
var held: Array[bool] = []

func _init() -> void:
    held.resize(InputAction.Action.COUNT)
    for i in held.size():
        held[i] = false

func is_held(action_id: int) -> bool:
    if action_id < 0 or action_id >= held.size():
        return false
    return held[action_id]

func set_held(action_id: int, value: bool) -> void:
    if action_id < 0 or action_id >= held.size():
        return
    held[action_id] = value

func clear_axes() -> void:
    move_axis = Vector2.ZERO
    look_axis = Vector2.ZERO 
