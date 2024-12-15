extends Entity
class_name Player

var headbob_time := 0.0

@onready var mouse_sensitivity := 0.006
@onready var game_camera := $Head/GameCamera as GameCamera
@onready var headbob_move_amount := 0.06
@onready var headbob_frequency := 2.4

func ready():
	for child in %Model.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			game_camera.rotate_x(-event.relative.y * mouse_sensitivity)
			game_camera.rotation.x = clamp(game_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90));


func _headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	game_camera.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_move_amount,
		sin(headbob_time * headbob_frequency) * headbob_move_amount,
		0
	)


func _physics_process(delta) -> void:
	var input_dir := Input.get_vector("left", "right", "down", "up").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			air_movement.handle_jump(self)
		ground_movement.handle_ground_physics(self)
		_headbob_effect(delta)
	else:
		air_movement.handle_air_physics(self)
	move_and_slide()
	
