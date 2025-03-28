extends Node3D
class_name DashHandler

@export var cooldown_value := 0.5
@export var entity : Entity
@export var speed := 170.0
@export var duration := 0.08
@export var dash_consumption := 50.0
@export var speed_lines : MeshInstance3D
@export var speed_lines_duration := 0.1

var dash: Dash

@onready var current_speed = speed
@onready var current_duration = duration
@onready var current_speed_lines_duration = speed_lines_duration
@onready var cooldown := $Cooldown as Timer

func _ready():
	cooldown.wait_time = cooldown_value
	speed_lines.visible = false

func trigger_dash(direction: Vector3, _speed:=current_speed as float, \
_duration:=current_duration as float) -> void:
	var dash_data := {
		speed = _speed,
		duration = _duration,
		entity = entity,
		direction = _set_direction(direction)
	}
	dash = Dash.create(dash_data)
	
	#entity.hitbox.disable()
	_show_speed_lines()
	
	dash.dash_finished.connect(_enable_hitbox)
	dash.dash_finished.connect(_hide_speed_lines)
	entity.add_loss_of_control_effect(dash, dash.dash_finished)
	cooldown.start()

func _set_direction(direction: Vector3) -> Vector3:
	return direction.normalized()

func _enable_hitbox() -> void:
	return

func _show_speed_lines() -> void:
	speed_lines.visible = true

func _hide_speed_lines() -> void:
	await get_tree().create_timer(current_speed_lines_duration).timeout
	speed_lines.visible = false
