class_name IConnectivityService
extends Node

signal connectivity_changed(new_state: NetworkState.State)

func check_connectivity() -> void:
    push_error("IConnectivityService: check_connectivity() must be overridden by implementation.") 
