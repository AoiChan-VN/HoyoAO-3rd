class_name ApplicationState
extends RefCounted

enum Id {
    BOOTING,
    INITIALIZING,
    CHECKING_REQUIREMENTS,
    BLOCKED,
    READY,
    RUNNING,
    SUSPENDED,
    RECOVERING,
    SHUTTING_DOWN,
    FAILED
}

static func to_name(state: int) -> String:
    match state:
        Id.BOOTING:
            return "BOOTING"
        Id.INITIALIZING:
            return "INITIALIZING"
        Id.CHECKING_REQUIREMENTS:
            return "CHECKING_REQUIREMENTS"
        Id.BLOCKED:
            return "BLOCKED"
        Id.READY:
            return "READY"
        Id.RUNNING:
            return "RUNNING"
        Id.SUSPENDED:
            return "SUSPENDED"
        Id.RECOVERING:
            return "RECOVERING"
        Id.SHUTTING_DOWN:
            return "SHUTTING_DOWN"
        Id.FAILED:
            return "FAILED"
    return "UNKNOWN" 
