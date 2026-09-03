class_name AppFlowState
extends RefCounted

enum State {
    BOOT,
    PLATFORM_CHECK,
    NETWORK_CHECK,
    VERSION_CHECK,
    READY,
    BLOCKED
}
