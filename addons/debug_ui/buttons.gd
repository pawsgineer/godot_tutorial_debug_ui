class_name DebugUIButtons extends HFlowContainer

@onready var _enabled: bool = OS.is_debug_build()

var _btn_scene := preload("button.tscn")

func push(text: String, callback: Callable) -> void:
    if not _enabled:
        return

    var btn: Button = _btn_scene.instantiate()
    btn.text = text
    btn.pressed.connect(callback)
    add_child(btn)
