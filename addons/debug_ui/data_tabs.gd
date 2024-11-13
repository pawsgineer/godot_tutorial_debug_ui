class_name DebugUIDataTabs extends TabContainer

@onready var _enabled: bool = OS.is_debug_build()

var _data: Dictionary
var _data_tab_nodes: Dictionary # Dictionary[RichTextLabel]
var _data_tab_scene := preload("data_tab.tscn")

func push(key: String, data: Dictionary, clear := false) -> void:
    if not _enabled:
        return

    var old_data: Dictionary = _data.get_or_add(key, {})
    if clear:
        old_data.clear()

    old_data.merge(data, true)

    _update()

func _update() -> void:
    for key: String in _data:
        var node: RichTextLabel = _data_tab_nodes.get(key)
        if node == null:
            node = _data_tab_scene.instantiate()
            node.name = key
            _data_tab_nodes[key] = node
            add_child(node)

        node.text = pformat(_data[key])

func pformat(msg: Variant, indent: String = "  ", sort := false) -> String:
    return JSON.stringify(msg, indent, sort)
