extends Node
class_name AirMovement

signal upward_force_applied()

@export var jump_velocity := 8.0
@export var air_speed := 8.0

func apply_gravity(entity:Entity) -> void:
	entity.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") \
	* get_process_delta_time()

func apply_upward_force(entity:Entity) -> void:
	upward_force_applied.emit()
	entity.velocity.y = jump_velocity
