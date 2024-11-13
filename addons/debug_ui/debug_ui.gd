class_name DebugUI extends Control

@onready var _enabled: bool = OS.is_debug_build()

@onready var notify: DebugUINotify = get_node("Notify")
@onready var log: DebugUILog = get_node("Log")
@onready var data: DebugUIDataTabs = get_node("DataTabs")
@onready var buttons: DebugUIButtons = get_node("Buttons")

func _unhandled_input(event: InputEvent) -> void:
    if not _enabled:
        return

    if event.is_action_pressed("debug_toggle"):
        visible = not visible

func _ready() -> void:
    if not _enabled:
        visible = false
        return

    mouse_filter = Control.MOUSE_FILTER_PASS
