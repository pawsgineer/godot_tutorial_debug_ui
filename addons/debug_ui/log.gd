class_name DebugUILog extends RichTextLabel

const LOG_LIMIT: int = 40

@onready var _enabled: bool = OS.is_debug_build()

var _log: Array[String]

func push(text: String, time := true) -> void:
    if not _enabled:
        return

    var prefix: String
    if time:
        prefix = Time.get_time_string_from_system()
    _log.push_front(": ".join([prefix, text]))
    _log.resize(LOG_LIMIT)
    _update()

func push_pretty(content: Variant, time := true) -> void:
    push(pformat(content), time)

func _update() -> void:
    text = "\n".join(_log)

func pformat(msg: Variant, indent: String = "  ", sort := false) -> String:
    return JSON.stringify(msg, indent, sort)
