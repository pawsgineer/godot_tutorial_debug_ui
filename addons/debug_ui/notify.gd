class_name DebugUINotify extends Label

const LIFETIME: float = 2

@onready var _enabled: bool = OS.is_debug_build()

@onready var _notify_timer: Timer = Timer.new()

var _notifies: Array[Notify]

class Notify:
    var content: String
    var created: int

    func _init(p_text: String) -> void:
        content = p_text
        created = Time.get_ticks_msec()

    func is_expired(lifetime: float) -> bool:
        return created + lifetime < Time.get_ticks_msec()

func _ready() -> void:
    if not _enabled:
        return

    _notify_timer.wait_time = LIFETIME
    _notify_timer.timeout.connect(_update)
    add_child(_notify_timer)

    _update()

func push(text: String) -> void:
    if not _enabled:
        return

    _notifies.append(Notify.new(text))
    _update()

func _update() -> void:
    _notifies = _notifies.filter(
        func(n: Notify) -> bool:
            return not n.is_expired(LIFETIME)
    )

    var lines: Array[String]
    for n in _notifies:
        lines.append(n.content)

    text = "\n".join(lines)

    if _notifies.is_empty():
        _notify_timer.stop()
        return

    _notify_timer.start()
