extends Node

const CONFIG_PATH := "res://config/application/application_config.json"

var _context: BootContext
var _logger: AppLogger
var _config: AppConfig
var _runtime: AppRuntime
var _boot_machine: BootStateMachine

func _ready() -> void:
    _context = BootContext.new()
    _logger = AppLogger.new()
    _logger.set_min_level(AppLogger.Level.DEBUG)

    _boot_machine = BootStateMachine.new()
    _boot_machine.state_changed.connect(_on_boot_state_changed)

    _runtime = AppRuntime.new()
    if not _runtime.attach_diagnostics(_context, _logger):
        _fail("Diagnostics attachment failed")
        return

    _logger.info("BOOT", "Application start")

    if not _boot_machine.start():
        _fail("Boot state machine failed to start")
        return

    _execute_boot()

func _exit_tree() -> void:
    if _runtime != null:
        _runtime.shutdown()

func _execute_boot() -> void:
    if not _enter_boot_state(BootState.Id.INITIALIZING_DIAGNOSTICS):
        return

    _logger.info("BOOT", "Logger online")
    _context.diagnostics_ready = true

    if not _set_application_state(ApplicationState.Id.INITIALIZING):
        return

    if not _enter_boot_state(BootState.Id.LOADING_CONFIGURATION):
        return

    if not _load_configuration():
        return

    if not _enter_boot_state(BootState.Id.DETECTING_PLATFORM):
        return

    _logger.info("PLATFORM", "%s platform detected" % _context.platform_name)

    if not _enter_boot_state(BootState.Id.INITIALIZING_SERVICES):
        return

    if not _runtime.initialize_services():
        _fail("Runtime services initialization failed")
        return

    _logger.info("SERVICE", "Runtime services ready")

    if not _enter_boot_state(BootState.Id.VALIDATING_RUNTIME):
        return

    if not _set_application_state(ApplicationState.Id.CHECKING_REQUIREMENTS):
        return

    if not _runtime.validate():
        _fail("Runtime validation failed")
        return

    if not _enter_boot_state(BootState.Id.READY):
        return

    if not _set_application_state(ApplicationState.Id.READY):
        return

    _context.runtime_ready = true

    if not _runtime.enter_running():
        _fail("Application failed to enter RUNNING")
        return

    _logger.info("BOOT", "Application runtime ready")

func _load_configuration() -> bool:
    _config = AppConfig.new()

    if not _config.load_from_file(CONFIG_PATH):
        _fail("Configuration load failed")
        return false

    _context.configuration_loaded = true
    _apply_log_level()

    if not _runtime.attach_config(_config):
        _fail("Runtime configuration attachment failed")
        return false

    _logger.info(
        "CONFIG",
        "Configuration loaded: environment=%s, app_version=%s" % [
            _config.environment,
            _config.app_version
        ]
    )

    return true

func _apply_log_level() -> void:
    match _config.log_level.to_lower():
        "trace":
            _logger.set_min_level(AppLogger.Level.TRACE)
        "debug":
            _logger.set_min_level(AppLogger.Level.DEBUG)
        "info":
            _logger.set_min_level(AppLogger.Level.INFO)
        "warning":
            _logger.set_min_level(AppLogger.Level.WARNING)
        "error":
            _logger.set_min_level(AppLogger.Level.ERROR)
        "fatal":
            _logger.set_min_level(AppLogger.Level.FATAL)
        _:
            _logger.set_min_level(AppLogger.Level.INFO)
            _logger.warning("CONFIG", "Unknown log_level; fallback to INFO")

func _enter_boot_state(state: BootState.Id) -> bool:
    if _boot_machine == null:
        _fail("Boot state machine unavailable")
        return false

    if not _boot_machine.transition_to(state):
        _fail("Invalid boot transition to %s" % BootState.to_name(state))
        return false

    return true

func _set_application_state(state: ApplicationState.Id) -> bool:
    if _runtime == null:
        _fail("Application runtime unavailable")
        return false

    if not _runtime.transition_application(state):
        _fail("Invalid application state transition to %s" % ApplicationState.to_name(state))
        return false

    return true

func _on_boot_state_changed(previous_state: int, new_state: int) -> void:
    if _logger == null:
        return

    _logger.info("BOOT_STATE", "%s -> %s" % [
        BootState.to_name(previous_state),
        BootState.to_name(new_state)
    ])

func _fail(message: String) -> void:
    if _context != null:
        _context.failure_message = message

    if _boot_machine != null:
        _boot_machine.transition_to(BootState.Id.FAILED)

    if _runtime != null:
        _runtime.fail(message)
    elif _logger != null:
        _logger.fatal("BOOT", message)

    get_tree().quit(1)
