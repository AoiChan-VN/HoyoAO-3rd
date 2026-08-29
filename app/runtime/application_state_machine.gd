class_name ApplicationStateMachine
extends RefCounted

signal state_changed(previous_state: int, new_state: int)

var _current: ApplicationState.Id = ApplicationState.Id.BOOTING

func current() -> ApplicationState.Id:
    return _current

func transition_to(next_state: ApplicationState.Id) -> bool:
    if not can_transition(_current, next_state):
        return false

    var previous := _current
    _current = next_state
    state_changed.emit(int(previous), int(next_state))
    return true

func can_transition(from_state: ApplicationState.Id, to_state: ApplicationState.Id) -> bool:
    if from_state == to_state:
        return false

    match from_state:
        ApplicationState.Id.BOOTING:
            return _is_any(to_state, [
                ApplicationState.Id.INITIALIZING,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.INITIALIZING:
            return _is_any(to_state, [
                ApplicationState.Id.CHECKING_REQUIREMENTS,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.CHECKING_REQUIREMENTS:
            return _is_any(to_state, [
                ApplicationState.Id.READY,
                ApplicationState.Id.BLOCKED,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.READY:
            return _is_any(to_state, [
                ApplicationState.Id.RUNNING,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.RUNNING:
            return _is_any(to_state, [
                ApplicationState.Id.SUSPENDED,
                ApplicationState.Id.RECOVERING,
                ApplicationState.Id.BLOCKED,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.BLOCKED:
            return _is_any(to_state, [
                ApplicationState.Id.RECOVERING,
                ApplicationState.Id.SHUTTING_DOWN,
                ApplicationState.Id.FAILED
            ])

        ApplicationState.Id.SUSPENDED:
            return _is_any(to_state, [
                ApplicationState.Id.RUNNING,
                ApplicationState.Id.SHUTTING_DOWN,
                ApplicationState.Id.FAILED
            ])

        ApplicationState.Id.RECOVERING:
            return _is_any(to_state, [
                ApplicationState.Id.RUNNING,
                ApplicationState.Id.BLOCKED,
                ApplicationState.Id.FAILED,
                ApplicationState.Id.SHUTTING_DOWN
            ])

        ApplicationState.Id.SHUTTING_DOWN:
            return false

        ApplicationState.Id.FAILED:
            return to_state == ApplicationState.Id.SHUTTING_DOWN

    return false

func _is_any(state: ApplicationState.Id, states: Array) -> bool:
    return states.has(state) 
