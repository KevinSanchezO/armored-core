extends Node
class_name GroundMovement

@export var walk_speed := 7.0
@export var sprint_speed := 8.5

func handle_ground_physics(entity:Entity) -> void:
	entity.velocity.x = entity.wish_dir.x * walk_speed
	entity.velocity.z = entity.wish_dir.z * walk_speed
	
