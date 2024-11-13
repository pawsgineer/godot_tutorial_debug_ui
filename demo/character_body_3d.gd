extends CharacterBody3D

const SPEED = 1.0

@export var random_position_range: float = -4.0

@onready var _name_label: Label3D = get_node("NameLabel")
@onready var _start_position: Vector3 = global_position

var _target_position: Vector3

var _paused := false

func _ready() -> void:
    _name_label.text = name
    _randomize_target_position()

    DbgUI.log.push(name + " is ready!")
    DbgUI.notify.push(name + " is ready!")
    DbgUI.buttons.push(
        name + ": toggle movement",
        func() -> void:
            _paused = not _paused
            DbgUI.notify.push(name + " movement enabled: " + str(_paused))
    )

func _physics_process(_delta: float) -> void:
    DbgUI.data.push(
        name + "(phys_proc)",
        {"_paused": _paused},
        true, # Clear data at start of the tick
    )

    if _paused:
        return

    if abs(_target_position - global_position).length() < 0.1:
        _randomize_target_position()
        DbgUI.log.push(
            name + " reached target. New target: " + str(_target_position),
        )

    var motion_dir := (_target_position - global_position).normalized()
    var direction := motion_dir

#     var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#     var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

    DbgUI.data.push(name + "(phys_proc)", {
        "velocity": velocity,
        "global_position": global_position,
        "_target_position": _target_position,
        "_start_position": _start_position,
        "motion_dir": motion_dir,
        "direction": direction,
        "pos length": abs(_target_position - global_position).length(),
    })

func _randomize_target_position():
    _target_position = _start_position + Vector3(
        randf_range(0, random_position_range),
        global_position.y,
        randf_range(0, random_position_range),
    )
