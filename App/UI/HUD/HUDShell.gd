class_name HUDShell
extends Control

@export var input_service_path: NodePath
@export var gate_path: NodePath

var _input_service: InputService
var _gate: NetworkGate
var _debug_label: Label
var _move_stick: TouchStick

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false

    _input_service = get_node_or_null(input_service_path) as InputService
    _gate = get_node_or_null(gate_path) as NetworkGate

    if _input_service == null:
        push_error("HUDShell: InputService is missing.")
        return

    if _gate == null:
        push_error("HUDShell: NetworkGate is missing.")
        return

    _build_ui()

    _input_service.action_pressed.connect(_on_action_pressed_debug)
    _gate.state_changed.connect(_on_gate_state_changed)

    _on_gate_state_changed(_gate.get_current_state())

func _on_gate_state_changed(new_state: int) -> void:
    var validated: bool = new_state == NetworkState.State.VALIDATED
    visible = validated

    if not validated and _input_service != null:
        _input_service.reset()

func _on_action_pressed_debug(action_id: int) -> void:
    if _debug_label != null:
        _debug_label.text = "Action: " + InputAction.get_name(action_id)

func _on_move_axis_changed(axis: Vector2) -> void:
    if _input_service != null:
        _input_service.set_move_axis(axis)

func _on_action_button_down(action_id: int) -> void:
    if _input_service != null:
        _input_service.press_action(action_id)

func _on_action_button_up(action_id: int) -> void:
    if _input_service != null:
        _input_service.release_action(action_id)

func _on_action_button_exited(action_id: int) -> void:
    if _input_service != null and _input_service.is_action_held(action_id):
        _input_service.release_action(action_id)

func _on_menu_button_pressed() -> void:
    if _input_service != null:
        _input_service.trigger_action(InputAction.Action.MENU)

func _build_ui() -> void:
    var root_margin := MarginContainer.new()
    root_margin.anchor_left = 0.0
    root_margin.anchor_top = 0.0
    root_margin.anchor_right = 1.0
    root_margin.anchor_bottom = 1.0
    root_margin.offset_left = 0.0
    root_margin.offset_top = 0.0
    root_margin.offset_right = 0.0
    root_margin.offset_bottom = 0.0
    root_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_margin.add_theme_constant_override("margin_left", 32)
    root_margin.add_theme_constant_override("margin_top", 32)
    root_margin.add_theme_constant_override("margin_right", 32)
    root_margin.add_theme_constant_override("margin_bottom", 32)
    add_child(root_margin)

    var vertical := VBoxContainer.new()
    vertical.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_margin.add_child(vertical)

    var top_bar := HBoxContainer.new()
    top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
    vertical.add_child(top_bar)

    _debug_label = Label.new()
    _debug_label.text = "HUD ready"
    _debug_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    top_bar.add_child(_debug_label)

    var top_spacer := Control.new()
    top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    top_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    top_bar.add_child(top_spacer)

    var menu_button := Button.new()
    menu_button.text = "Menu"
    menu_button.focus_mode = Control.FOCUS_NONE
    menu_button.mouse_filter = Control.MOUSE_FILTER_STOP
    menu_button.custom_minimum_size = Vector2(88.0, 56.0)
    menu_button.pressed.connect(_on_menu_button_pressed)
    top_bar.add_child(menu_button)

    var middle_spacer := Control.new()
    middle_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    middle_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    vertical.add_child(middle_spacer)

    var bottom_bar := HBoxContainer.new()
    bottom_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
    vertical.add_child(bottom_bar)

    _move_stick = TouchStick.new()
    _move_stick.axis_changed.connect(_on_move_axis_changed)
    bottom_bar.add_child(_move_stick)

    var bottom_spacer := Control.new()
    bottom_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    bottom_bar.add_child(bottom_spacer)

    var action_grid := GridContainer.new()
    action_grid.columns = 2
    action_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
    bottom_bar.add_child(action_grid)

    _add_action_button(action_grid, InputAction.Action.ATTACK, "Attack")
    _add_action_button(action_grid, InputAction.Action.DODGE, "Dodge")
    _add_action_button(action_grid, InputAction.Action.SKILL_1, "Skill 1")
    _add_action_button(action_grid, InputAction.Action.SKILL_2, "Skill 2")
    _add_action_button(action_grid, InputAction.Action.ULTIMATE, "Ultimate")
    _add_action_button(action_grid, InputAction.Action.INTERACT, "Interact")

func _add_action_button(parent: Control, action_id: int, button_text: String) -> void:
    var button := Button.new()
    button.text = button_text
    button.focus_mode = Control.FOCUS_NONE
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.custom_minimum_size = Vector2(96.0, 96.0)

    button.button_down.connect(_on_action_button_down.bind(action_id))
    button.button_up.connect(_on_action_button_up.bind(action_id))
    button.mouse_exited.connect(_on_action_button_exited.bind(action_id))

    parent.add_child(button) 
