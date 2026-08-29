class_name AppRuntime
extends RefCounted

var _state_machine := ApplicationStateMachine.new()
var _logger: AppLogger
var _context: BootContext
var _config: AppConfig
var _services_initialized := false

func attach_diagnostics(context: BootContext, logger: AppLogger) -> bool:
    if context == null or logger == null:
        return false

    _context = context
    _logger = logger

    if not _state_machine.state_changed.is_connected(_on_application_state_changed):
        _state_machine.state_changed.connect(_on_application_state_changed)

    return true

func attach_config(config: AppConfig) -> bool:
    if config == null or _context == null or _logger == null:
        return false

    _config = config
    _context.app_version = _config.app_version
    return true

func initialize_services() -> bool:
    if _context == null or _logger == null or _config == null:
        return false

    _services_initialized = true
    return true

func validate() -> bool:
    return (
        _services_initialized
        and _context != null
        and _logger != null
        and _config != null
        and _context.configuration_loaded
        and _context.diagnostics_ready
    )

func transition_application(next_state: ApplicationState.Id) -> bool:
    return _state_machine.transition_to(next_state)

func enter_running() -> bool:
    return _state_machine.transition_to(ApplicationState.Id.RUNNING)

func fail(message: String) -> void:
    if _context != null:
        _context.failure_message = message

    if _logger != null:
        _logger.fatal("BOOT", message)

    _state_machine.transition_to(ApplicationState.Id.FAILED)

func shutdown() -> void:
    if _state_machine.current() == ApplicationState.Id.SHUTTING_DOWN:
        return

    if _state_machine.transition_to(ApplicationState.Id.SHUTTING_DOWN):
        if _logger != null:
            _logger.info("RUNTIME", "Runtime shutdown")

func _on_application_state_changed(previous_state: int, new_state: int) -> void:
    if _logger == null:
        return

    _logger.info("APP_STATE", "%s -> %s" % [
        ApplicationState.to_name(previous_state),
        ApplicationState.to_name(new_state)
    ])
