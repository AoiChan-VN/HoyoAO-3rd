class_name BootState
extends RefCounted

enum Id {
    NONE,
    STARTING,
    INITIALIZING_DIAGNOSTICS,
    LOADING_CONFIGURATION,
    DETECTING_PLATFORM,
    INITIALIZING_SERVICES,
    VALIDATING_RUNTIME,
    READY,
    FAILED
}

static func to_name(state: int) -> String:
    match state:
        Id.NONE:
            return "NONE"
        Id.STARTING:
            return "STARTING"
        Id.INITIALIZING_DIAGNOSTICS:
            return "INITIALIZING_DIAGNOSTICS"
        Id.LOADING_CONFIGURATION:
            return "LOADING_CONFIGURATION"
        Id.DETECTING_PLATFORM:
            return "DETECTING_PLATFORM"
        Id.INITIALIZING_SERVICES:
            return "INITIALIZING_SERVICES"
        Id.VALIDATING_RUNTIME:
            return "VALIDATING_RUNTIME"
        Id.READY:
            return "READY"
        Id.FAILED:
            return "FAILED"
    return "UNKNOWN" 
