extends RayCast3D
class_name RaycastRangeWeapon

const MULTIPLIER := 20
var spread:float


func cast_ray() -> Vector3:
	var forward_direction := global_transform.basis.z.normalized() * -1
	var spread_vector := get_random_spread_vector()
	
	var world_spread := (forward_direction + spread_vector).normalized() * MULTIPLIER
		
	return world_spread


func get_random_spread_vector() -> Vector3:
	return Vector3(
			randf_range(-spread, spread), 
			randf_range(-spread, spread), 
			randf_range(-spread, spread) * 0.5
	)
