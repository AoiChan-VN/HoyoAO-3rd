class_name TouchStick
extends Control

signal axis_changed(axis: Vector2)

@export var stick_radius: float = 80.0

var _value: Vector2 = Vector2.ZERO
var _active_touch_index: int = -1

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP
    custom_minimum_size = Vector2(stick_radius * 2.0, stick_radius * 2.0)

func get_value() -> Vector2:
    return _value

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if _active_touch_index == -1:
                _active_touch_index = event.index
                _update_value(event.position)
                accept_event()
        else:
            if event.index == _active_touch_index:
                _active_touch_index = -1
                _set_value(Vector2.ZERO)
                accept_event()

    elif event is InputEventScreenDrag:
        if event.index == _active_touch_index:
            _update_value(event.position)
            accept_event()

func _update_value(local_position: Vector2) -> void:
    var center: Vector2 = size * 0.5
    var radius: float = _get_radius()
    var raw: Vector2 = (local_position - center) / radius
    _set_value(raw.limit_length(1.0))

func _set_value(value: Vector2) -> void:
    if _value == value:
        return

    _value = value
    axis_changed.emit(_value)
    queue_redraw()

func _get_radius() -> float:
    var radius: float = min(size.x, size.y) * 0.5
    if radius <= 0.0:
        return stick_radius
    return radius

func _draw() -> void:
    var center: Vector2 = size * 0.5
    var radius: float = _get_radius()

    draw_circle(center, radius, Color(1.0, 1.0, 1.0, 0.12))
    draw_circle(center + _value * radius, 32.0, Color(1.0, 1.0, 1.0, 0.45)) 
