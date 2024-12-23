extends Camera3D
class_name GameCamera

@export var headbob_move_amount := 0.06
@export var headbob_frequency := 2.1

var headbob_time := 0.0

func headbob_effect():
	headbob_time += get_process_delta_time() * self.velocity.length()
	self.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_move_amount,
		sin(headbob_time * headbob_frequency) * headbob_move_amount,
		0
	)
