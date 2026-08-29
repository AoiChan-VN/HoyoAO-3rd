class_name AppRuntime
extends RefCounted

enum State { BOOTING, READY, FAILED, STOPPED }

var _state: State = State.BOOTING
var _logger: AppLogger
var _config: AppConfig
var _context: BootContext

func initialize(context: BootContext, logger: AppLogger, config: AppConfig) -> bool:
    if context == null or logger == null or config == null:
        _state = State.FAILED
        if logger != null:
            logger.error("RUNTIME", "Initialization failed due to missing required dependencies")
        return false

    _context = context
    _logger = logger
    _config = config
    _context.app_version = _config.app_version
    _state = State.READY
    return true

func is_ready() -> bool:
    return _state == State.READY

func shutdown() -> void:
    if _state != State.READY:
        return

    if _logger != null:
        _logger.info("RUNTIME", "Runtime shutdown")

    _state = State.STOPPED 
