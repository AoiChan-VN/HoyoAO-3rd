extends Node

const CONFIG_PATH := "res://config/application/application_config.json"

var _context: BootContext
var _logger: AppLogger
var _config: AppConfig
var _runtime: AppRuntime

func _ready() -> void:
    _context = BootContext.new()
    _logger = AppLogger.new()
    _logger.set_min_level(AppLogger.Level.DEBUG)

    _logger.info("BOOT", "Application start")
    _logger.info("BOOT", "Logger online")

    _context.diagnostics_ready = true
    _logger.info("BOOT", "Diagnostics initialized")

    _config = AppConfig.new()
    if not _config.load_from_file(CONFIG_PATH):
        _fail("Configuration load failed")
        return

    _context.configuration_loaded = true
    _apply_log_level()
    _logger.info(
        "CONFIG",
        "Configuration loaded: environment=%s, app_version=%s" % [
            _config.environment,
            _config.app_version
        ]
    )

    _logger.info("PLATFORM", "%s platform detected" % _context.platform_name)

    _runtime = AppRuntime.new()
    if not _runtime.initialize(_context, _logger, _config):
        _fail("Runtime initialization failed")
        return

    _context.runtime_ready = true
    _logger.info("SERVICE", "Runtime services ready")
    _logger.info("BOOT", "Application runtime ready")

func _exit_tree() -> void:
    if _runtime != null and _runtime.is_ready():
        _runtime.shutdown()

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

func _fail(message: String) -> void:
    _context.failure_message = message
    if _logger != null:
        _logger.fatal("BOOT", message)
    get_tree().quit(1) 
