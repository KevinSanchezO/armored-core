extends Node
class_name AirMovement

@export var jump_velocity := 6.0

func handle_air_physics(entity:Entity) -> void:
	entity.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") \
	* get_process_delta_time()

func handle_jump(entity:Entity) -> void:
	entity.velocity.y = jump_velocity
