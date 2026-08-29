class_name BootStateMachine
extends RefCounted

signal state_changed(previous_state: int, new_state: int)

var _current: BootState.Id = BootState.Id.NONE

func current() -> BootState.Id:
    return _current

func start() -> bool:
    return transition_to(BootState.Id.STARTING)

func transition_to(next_state: BootState.Id) -> bool:
    if not can_transition(_current, next_state):
        return false

    var previous := _current
    _current = next_state
    state_changed.emit(int(previous), int(next_state))
    return true

func can_transition(from_state: BootState.Id, to_state: BootState.Id) -> bool:
    if from_state == to_state:
        return false

    match from_state:
        BootState.Id.NONE:
            return _is_any(to_state, [
                BootState.Id.STARTING,
                BootState.Id.FAILED
            ])

        BootState.Id.STARTING:
            return _is_any(to_state, [
                BootState.Id.INITIALIZING_DIAGNOSTICS,
                BootState.Id.FAILED
            ])

        BootState.Id.INITIALIZING_DIAGNOSTICS:
            return _is_any(to_state, [
                BootState.Id.LOADING_CONFIGURATION,
                BootState.Id.FAILED
            ])

        BootState.Id.LOADING_CONFIGURATION:
            return _is_any(to_state, [
                BootState.Id.DETECTING_PLATFORM,
                BootState.Id.FAILED
            ])

        BootState.Id.DETECTING_PLATFORM:
            return _is_any(to_state, [
                BootState.Id.INITIALIZING_SERVICES,
                BootState.Id.FAILED
            ])

        BootState.Id.INITIALIZING_SERVICES:
            return _is_any(to_state, [
                BootState.Id.VALIDATING_RUNTIME,
                BootState.Id.FAILED
            ])

        BootState.Id.VALIDATING_RUNTIME:
            return _is_any(to_state, [
                BootState.Id.READY,
                BootState.Id.FAILED
            ])

        BootState.Id.READY:
            return to_state == BootState.Id.FAILED

        BootState.Id.FAILED:
            return false

    return false

func _is_any(state: BootState.Id, states: Array) -> bool:
    return states.has(state) 
