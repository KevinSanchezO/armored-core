extends Node3D
class_name FaceDirection

## If less than 0, rotation will be instant
@export_range(-1.0, 50.0, 0.2) var turn_speed := 5.0

var current_direction: Vector3:
	get:
		return -global_transform.basis.z

func face_point(point: Vector3, delta := get_process_delta_time()) -> void:
	var direction := (point - global_position).normalized()
	var target_rotation := atan2(direction.x, direction.z)
	
	var angle_to := wrapf(target_rotation - rotation.y, -PI, PI)
	
	if turn_speed <= 0.0:
		rotation.y += angle_to
	else:
		rotation.y += signf(angle_to) * minf(delta * turn_speed, absf(angle_to))
