extends Marker3D
class_name Hurtcast


@export var damage := 0.0
@export_range(1, 100) var number_of_rays := 1
@export_range(1.0, 10000, 0.1) var cast_range := 25.0
@export_range(0.0, 1.0, 0.001) var spread := 0.0
@export_flags_3d_physics var ray_cast_mask: int

@onready var directional_node := $DirectionalNode as Node3D

func fire_rays() -> Array[Dictionary]:
	var hits : Array[Dictionary] = []
	
	for i in number_of_rays:
		var hit_data := cast_ray()
		if hit_data == {}:
			continue
		
		hits.append(hit_data)
		
		if not hit_data["collider"] is Hurtbox:
			continue
		
		var hit := hit_data["collider"] as Hurtbox
		hit.receive_damage(damage)
	
	return hits


func cast_ray() -> Dictionary:
	var space_state := get_world_3d().direct_space_state
	
	var adjusted_target_position := directional_node.global_position + get_random_spread_vector()
	
	var direction := (adjusted_target_position - global_position).normalized()
	
	var query := PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + (direction * cast_range),
			ray_cast_mask
	)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)


func get_random_spread_vector() -> Vector3:
	return Vector3(
			randf_range(-spread, spread), 
			randf_range(-spread, spread), 
			randf_range(-spread, spread)
	)
