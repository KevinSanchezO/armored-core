extends Entity
class_name Player

@export_group("Mouse Sensitivity")
@export_range(0.001, 0.01, 0.0001) var mouse_sensitivity := 0.006

@export_group("Base Tilt")
@export var tilt := 2.5

@onready var game_camera := $Head/GameCamera as GameCamera
@onready var energy_gauge := $EnergyGauge as EnergyGauge
@onready var dash_handler := $DashHandler as DashHandler

func ready() -> void:
	for child in %Model.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)


func _unhandled_input(event) -> void:
	if loss_of_control_effects != []:
		return
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			game_camera.rotate_x(-event.relative.y * mouse_sensitivity)
			game_camera.rotation.x = clamp(game_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90));


func _physics_process(_delta) -> void:
	air_movement.apply_gravity(self)
	
	if loss_of_control_effects != []:
		return
	
	var input_dir := Input.get_vector("left", "right", "down", "up").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	
	velocity_3d.accelerate(wish_dir)
	velocity_3d.move(self)
	
	_handle_boost()
	_handle_dash(wish_dir)
	_head_tilt(input_dir)


func _handle_boost() -> void:
	if Input.is_action_pressed("boost") and !energy_gauge.is_in_cooldown:
		air_movement.apply_upward_force(self)
		energy_gauge.is_consuming = true
	if Input.is_action_just_released("boost") or energy_gauge.is_in_cooldown:
		energy_gauge.is_consuming = false


func _handle_dash(input_dir:Vector3) -> void:
	if Input.is_action_just_pressed("dash") and dash_handler.cooldown.is_stopped()\
	and energy_gauge.energy_gauge > 0 and !energy_gauge.is_in_cooldown:
		energy_gauge.modify_gauge_directly(dash_handler.dash_consumption)
		dash_handler.trigger_dash(input_dir)


func _head_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(-tilt), 0.05)
	elif input_dir.x < 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(tilt), 0.05)
	else:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(0), 0.05)
	
	if input_dir.y > 0:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(-tilt), 0.05)
	elif input_dir.y < 0:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(tilt), 0.05)
	else:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(0), 0.05)
