extends Node
class_name AirMovement

signal upward_force_applied()

const GRAVITY := 9.8
const FALL_GRAVITY := 19.6

@export var jump_velocity := 12.0
@export var air_speed := 8.0

func apply_gravity(entity:Entity) -> void:
	if entity.velocity.y >= 0:
		entity.velocity.y -= GRAVITY * get_process_delta_time()
	else:
		entity.velocity.y -= FALL_GRAVITY * get_process_delta_time()

func apply_upward_force(entity:Entity) -> void:
	upward_force_applied.emit()
	entity.velocity.y = jump_velocity
