extends Node
class_name DashHandler

@export var cooldown_value := 0.5
@export var entity : Entity
@export var speed := 170.0
@export var duration := 0.08
@export var dash_consumption = 30.0

var dash: Dash

@onready var current_speed = speed
@onready var current_duration = duration
@onready var cooldown := $Cooldown as Timer

func _ready():
	cooldown.wait_time = cooldown_value

func trigger_dash(direction: Vector3, input_dir:=Vector2.ZERO, _speed:=current_speed as float, \
_duration:=current_duration as float) -> void:
	var dash_data := {
		speed = _speed,
		duration = _duration,
		entity = entity,
		direction = _set_direction(direction, input_dir)
	}
	dash = Dash.create(dash_data)
	#entity.hitbox.disable()
	dash.dash_finished.connect(_enable_hitbox)
	entity.add_loss_of_control_effect(dash, dash.dash_finished)
	cooldown.start()

func _set_direction(direction: Vector3, input_dir:Vector2) -> Vector3:
	if entity != null and input_dir == Vector2.ZERO:
		direction = -entity.global_transform.basis.z
	return direction.normalized()

func _enable_hitbox() -> void:
	return
