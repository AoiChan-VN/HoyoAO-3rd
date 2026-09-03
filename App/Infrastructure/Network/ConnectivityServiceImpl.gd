class_name ConnectivityServiceImpl
extends IConnectivityService

# Sử dụng endpoint 204 No Content của Google để check mạng chuẩn Android
const PING_URL: String = "https://clients3.google.com/generate_204"
const TIMEOUT_SECONDS: float = 5.0
const RECOVERY_INTERVAL_SECONDS: float = 3.0

var _http_request: HTTPRequest
var _check_timer: Timer
var _current_state: NetworkState.State = NetworkState.State.UNKNOWN

func _ready() -> void:
    _http_request = HTTPRequest.new()
    _http_request.timeout = TIMEOUT_SECONDS
    add_child(_http_request)
    _http_request.request_completed.connect(_on_request_completed)
    
    _check_timer = Timer.new()
    _check_timer.wait_time = RECOVERY_INTERVAL_SECONDS
    _check_timer.one_shot = false
    add_child(_check_timer)
    _check_timer.timeout.connect(_on_recovery_timeout)

func check_connectivity() -> void:
    _update_state(NetworkState.State.CHECKING)
    var error: Error = _http_request.request(PING_URL, [], HTTPClient.METHOD_GET)
    if error != OK:
        _update_state(NetworkState.State.BLOCKED)
        _start_recovery_loop()

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
    if result == HTTPRequest.RESULT_SUCCESS and response_code == 204:
        _update_state(NetworkState.State.VALIDATED)
        _stop_recovery_loop()
    else:
        _update_state(NetworkState.State.BLOCKED)
        _start_recovery_loop()

func _start_recovery_loop() -> void:
    if _check_timer.is_stopped():
        _update_state(NetworkState.State.RECOVERING)
        _check_timer.start()

func _stop_recovery_loop() -> void:
    if not _check_timer.is_stopped():
        _check_timer.stop()

func _on_recovery_timeout() -> void:
    check_connectivity()

func _update_state(new_state: NetworkState.State) -> void:
    if _current_state != new_state:
        _current_state = new_state
        connectivity_changed.emit(_current_state) 
