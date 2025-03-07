extends Marker3D
class_name Hurtcast


var number_of_rays : int
var cast_range : float
var spread : float
@export_flags_3d_physics var ray_cast_mask: int

@onready var directional_node := $DirectionalNode as Node3D

func set_values(_number_of_rays: int, _cast_range: float, _spread: float) -> void:
	number_of_rays = _number_of_rays
	cast_range = _cast_range
	spread = _spread


func fire_rays() -> Array[Dictionary]:
	var hits : Array[Dictionary] = []
	
	for i in number_of_rays:
		var hit_data := cast_ray()
		if hit_data == {}:
			continue
		
		hits.append(hit_data)
	
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
