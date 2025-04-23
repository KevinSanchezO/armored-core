extends Entity
class_name Player

@export_group("Mouse Sensitivity")
@export_range(0.001, 0.01, 0.0001) var mouse_sensitivity := 0.005

@export_group("Base Tilt")
@export var tilt := 4.0
@export var time_tilt := 0.05

@export_group("Weapon holder")
@export var weapon_rotation := 0.01

@onready var current_time_tilt := time_tilt

@onready var head := $Head as Node3D
@onready var view_container := $Head/ViewContainer as Node3D
@onready var camera_container := %CameraContainer as CameraContainer
@onready var game_camera := %GameCamera as GameCamera
@onready var range_weapon_manager := %RangeWeaponManager as RangeWeaponManager
@onready var support_weapon_manager := %SupportWeaponManager as SupportWeaponManager
@onready var speed_lines := %SpeedLines as SpeedLines
@onready var health_points := $HealthPoints as Health
@onready var dash_handler := $DashHandler as DashHandler
@onready var jump_handler := $JumpHandler as JumpHandler
@onready var energy_gauge := $EnergyGauge as EnergyGauge
@onready var slow_motion_handler := $SlowMotionHandler as SlowMotionHandler
@onready var repair_handler := $RepairHandler as RepairHandler


var air_momentum_dir := Vector3.ZERO
var mouse_input:Vector2


func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_speed)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_speed)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_tilt)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_tilt)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_air)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_air)


	for child in %Model.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)


func _unhandled_input(event) -> void:
	if loss_of_control_effects != []:
		return
	
	if Input.is_action_just_pressed("switch_weapon"):
		range_weapon_manager.switch_weapon()
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * mouse_sensitivity)
			view_container.rotate_x(-event.relative.y * mouse_sensitivity)
			view_container.rotation.x = clamp(view_container.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			mouse_input = event.relative


func _physics_process(_delta) -> void:
	velocity_3d.apply_gravity(self)
	
	if loss_of_control_effects != []:
		return
	
	var input_dir := Vector2.ZERO
	input_dir = Input.get_vector("left", "right", "down", "up").normalized()
	
	if input_dir != Vector2.ZERO:
		air_momentum_dir = head.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	
	if is_on_floor():
		air_momentum_dir = Vector3.ZERO
		wish_dir = head.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	else:
		if input_dir == Vector2.ZERO:
			wish_dir = air_momentum_dir
		else:
			wish_dir = air_momentum_dir
	
	velocity_3d.accelerate(wish_dir, velocity_3d.current_air_speed if not is_on_floor() else velocity_3d.current_speed)
	velocity_3d.move(self)
	
	_handle_repair()
	_handle_jump()
	_handle_dash(wish_dir)
	_head_tilt(input_dir)
	_weapon_sway()
	_weapon_tilt(input_dir)


func _handle_repair() -> void:
	if Input.is_action_just_pressed("repair") and repair_handler.check_repair_availability() \
	and repair_handler.timer.is_stopped():
		repair_handler.execute_repair()


func _handle_jump() -> void:
	if Input.is_action_pressed("jump") and !energy_gauge.is_in_cooldown\
	and jump_handler.jump_cooldown.is_stopped():
			velocity_3d.apply_upward_force(self)
			energy_gauge.modify_gauge_directly(jump_handler.jump_consumption)
			
	if Input.is_action_just_released("jump") and jump_handler.jump_cooldown.is_stopped():
		jump_handler.jump_cooldown.start()


func _handle_dash(wish_dir_dash:Vector3) -> void:
	if Input.is_action_just_pressed("dash") and dash_handler.cooldown.is_stopped()\
	and energy_gauge.energy_gauge > 0 and !energy_gauge.is_in_cooldown:
		energy_gauge.modify_gauge_directly(dash_handler.dash_consumption)
		
		if wish_dir_dash == Vector3.ZERO:
			wish_dir_dash = game_camera.global_transform.basis.z.normalized() * -1 # forward
		air_momentum_dir = wish_dir_dash
		
		dash_handler.trigger_dash(wish_dir_dash)


func _head_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(-tilt), current_time_tilt)
	elif input_dir.x < 0:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(tilt), current_time_tilt)
	else:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(0), current_time_tilt)
	
	if input_dir.y > 0:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(-tilt), current_time_tilt)
	elif input_dir.y < 0:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(tilt), current_time_tilt)
	else:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(0), current_time_tilt)


func _weapon_sway() -> void:
	var delta_time := get_process_delta_time() as float
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta_time)
	
	range_weapon_manager.rotation.x = lerp(range_weapon_manager.rotation.x, \
		mouse_input.y * weapon_rotation, 10 * delta_time)
	range_weapon_manager.rotation.y = lerp(range_weapon_manager.rotation.y, \
		mouse_input.x * weapon_rotation, 10 * delta_time)
	
	support_weapon_manager.rotation.x = lerp(support_weapon_manager.rotation.x, \
		mouse_input.y * weapon_rotation, 10 * delta_time)
	support_weapon_manager.rotation.y = lerp(support_weapon_manager.rotation.y, \
		mouse_input.x * weapon_rotation, 10 * delta_time)


func _weapon_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		range_weapon_manager.rotation.z = lerp_angle(range_weapon_manager.rotation.z, \
			deg_to_rad(-5), 0.05)
		support_weapon_manager.rotation.z = lerp_angle(support_weapon_manager.rotation.z, \
			deg_to_rad(-5), 0.05)
	elif input_dir.x < 0:
		range_weapon_manager.rotation.z = lerp_angle(range_weapon_manager.rotation.z, \
			deg_to_rad(5), 0.05)
		support_weapon_manager.rotation.z = lerp_angle(support_weapon_manager.rotation.z, \
			deg_to_rad(5), 0.05)
	else:
		range_weapon_manager.rotation.z = lerp_angle(range_weapon_manager.rotation.z, \
			deg_to_rad(0), 0.05)
		support_weapon_manager.rotation.z = lerp_angle(support_weapon_manager.rotation.z, \
			deg_to_rad(0), 0.05)
	
	if input_dir.y > 0:
		range_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(-5), 0.05)
		support_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(-5), 0.05)
	elif input_dir.y < 0:
		range_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(5), 0.05)
		support_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(5), 0.05)
	else:
		range_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(0), 0.05)
		support_weapon_manager.rotation.x = lerp_angle(range_weapon_manager.rotation.x, \
			deg_to_rad(0), 0.05)


func _enter_slow_motion_air() -> void:
	TweenManager.create_new_tween(velocity_3d, "current_jump_velocity",\
	velocity_3d.jump_velocity * 1.5, 0.5, velocity_3d.current_jump_velocity)
	
	TweenManager.create_new_tween(velocity_3d, "current_air_speed",\
	velocity_3d.air_speed * 2, 0.5, velocity_3d.current_air_speed)
	
	TweenManager.create_new_tween(velocity_3d, "current_gravity",\
	velocity_3d.GRAVITY * 2, 0.5, velocity_3d.current_gravity)
	
	TweenManager.create_new_tween(velocity_3d, "current_fall_gravity",\
	velocity_3d.FALL_GRAVITY * 2, 0.5, velocity_3d.current_fall_gravity)


func _exit_slow_motion_air() -> void:
	TweenManager.create_new_tween(velocity_3d, "current_jump_velocity",\
	velocity_3d.jump_velocity, 0.5, velocity_3d.current_jump_velocity)
	
	TweenManager.create_new_tween(velocity_3d, "current_air_speed",\
	velocity_3d.air_speed, 0.5, velocity_3d.current_air_speed)
	
	TweenManager.create_new_tween(velocity_3d, "current_gravity",\
	velocity_3d.GRAVITY, 0.5, velocity_3d.current_gravity)
	
	TweenManager.create_new_tween(velocity_3d, "current_fall_gravity",\
	velocity_3d.FALL_GRAVITY, 0.5, velocity_3d.current_fall_gravity)


func _enter_slow_motion_tilt() -> void:
	TweenManager.create_new_tween(self, "current_time_tilt", self.time_tilt / 2,\
	0.5, self.current_time_tilt)


func _exit_slow_motion_tilt() -> void:
	TweenManager.create_new_tween(self, "current_time_tilt", self.time_tilt,\
	0.5, self.current_time_tilt)


func _enter_slow_motion_speed() -> void:
	TweenManager.create_new_tween(velocity_3d, "current_speed", \
	velocity_3d.max_speed * 2, 0.5, velocity_3d.current_speed)


func _exit_slow_motion_speed() -> void:
	TweenManager.create_new_tween(velocity_3d, "current_speed", \
	velocity_3d.max_speed, 0.5, velocity_3d.current_speed)
