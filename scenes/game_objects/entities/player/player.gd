extends Entity
class_name Player

@export_group("Mouse Sensitivity")
@export_range(0.001, 0.01, 0.0001) var mouse_sensitivity := 0.006

@export_group("Base Tilt")
@export var tilt := 2.5
@export var time_tilt := 0.05

@export_group("Boosting")
@export var boost_consumption := 50.0
@export var boost_cooldown_value := 0.2

@export_group("Weapon holder")
@export var weapon_rotation := 0.01

@onready var current_time_tilt := time_tilt

@onready var game_camera := $Head/GameCamera as GameCamera
@onready var energy_gauge := $EnergyGauge as EnergyGauge
@onready var dash_handler := $DashHandler as DashHandler
@onready var boost_cooldown := $Velocity3d/BoostCooldown as Timer
@onready var health_pilot := $HealthPilot as Health
@onready var slow_motion_handler := $SlowMotionHandler as SlowMotionHandler
@onready var head := %Head as Node3D
@onready var weapon_holder := $Head/GameCamera/WeaponHolder as Node3D

var air_momentum_dir := Vector2.ZERO
var mouse_input:Vector2

func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_speed)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_speed)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_dash)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_dash)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_tilt)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_tilt)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_air)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_air)
	
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_energy)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_energy)
	
	boost_cooldown.wait_time = boost_cooldown_value
	
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
			#head.rotate_y(-event.relative.x * mouse_sensitivity)
			game_camera.rotate_x(-event.relative.y * mouse_sensitivity)
			game_camera.rotation.x = clamp(game_camera.rotation.x, deg_to_rad(-90), deg_to_rad(90));
			mouse_input = event.relative


func _physics_process(_delta) -> void:
	velocity_3d.apply_gravity(self)
	
	if loss_of_control_effects != []:
		return
	
	var input_dir := Input.get_vector("left", "right", "down", "up").normalized()
	
	if input_dir != Vector2.ZERO:
		air_momentum_dir = input_dir
	
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	
	if is_on_floor():
		air_momentum_dir = Vector2.ZERO
		velocity_3d.accelerate(wish_dir)
	else:
		if input_dir == Vector2.ZERO:
			wish_dir = self.global_transform.basis * Vector3(air_momentum_dir.x, 0.0, -air_momentum_dir.y)
		velocity_3d.accelerate(wish_dir, velocity_3d.current_air_speed)
	velocity_3d.move(self)
	
	_handle_boost()
	_handle_dash(wish_dir, input_dir)
	_head_tilt(input_dir)
	_weapon_sway()
	_weapon_tilt(input_dir)


func _handle_boost() -> void:
	if Input.is_action_just_pressed("boost") and !energy_gauge.is_in_cooldown\
	and boost_cooldown.is_stopped():
		velocity_3d.apply_upward_force(self)
		energy_gauge.modify_gauge_directly(boost_consumption)
		boost_cooldown.start()


func _handle_dash(wish_dir:Vector3, input_dir:Vector2) -> void:
	if Input.is_action_just_pressed("dash") and dash_handler.cooldown.is_stopped()\
	and energy_gauge.energy_gauge > 0 and !energy_gauge.is_in_cooldown:
		energy_gauge.modify_gauge_directly(dash_handler.dash_consumption)
		dash_handler.trigger_dash(wish_dir, input_dir)


func _head_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(-tilt), current_time_tilt)
	elif input_dir.x < 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(tilt), current_time_tilt)
	else:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(0), current_time_tilt)
	
	if input_dir.y > 0:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(-tilt), current_time_tilt)
	elif input_dir.y < 0:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(tilt), current_time_tilt)
	else:
		%Head.rotation.x = lerp_angle(%Head.rotation.x, deg_to_rad(0), current_time_tilt)


func _weapon_sway() -> void:
	var delta_time := get_process_delta_time() as float
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta_time)
	weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, mouse_input.y * weapon_rotation, 10 * delta_time)
	weapon_holder.rotation.y = lerp(weapon_holder.rotation.y, mouse_input.x * weapon_rotation, 10 * delta_time)


func _weapon_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		weapon_holder.rotation.z = lerp_angle(weapon_holder.rotation.z, deg_to_rad(-5), 0.05)
	elif input_dir.x < 0:
		weapon_holder.rotation.z = lerp_angle(weapon_holder.rotation.z, deg_to_rad(5), 0.05)
	else:
		weapon_holder.rotation.z = lerp_angle(weapon_holder.rotation.z, deg_to_rad(0), 0.05)


func _enter_slow_motion_energy() -> void:
	TweenManager.create_new_tween(energy_gauge.comsumption_timer, "wait_time",\
	energy_gauge.consumption_timer_value / 2, 0.5, energy_gauge.comsumption_timer.wait_time)


func _exit_slow_motion_energy() -> void:
	TweenManager.create_new_tween(energy_gauge.comsumption_timer, "wait_time",\
	energy_gauge.consumption_timer_value, 0.5, energy_gauge.comsumption_timer.wait_time)


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


func _enter_slow_motion_dash() -> void:
	TweenManager.create_new_tween(dash_handler, "current_speed", \
	dash_handler.speed * 2, 0.5, dash_handler.current_speed)
	
	TweenManager.create_new_tween(dash_handler, "current_duration", \
	dash_handler.duration / 2, 0.5, dash_handler.current_duration)
	
	TweenManager.create_new_tween(dash_handler.cooldown, "wait_time", \
	dash_handler.cooldown_value / 2, 0.5, dash_handler.cooldown.wait_time)


func _exit_slow_motion_dash() -> void:
	TweenManager.create_new_tween(dash_handler, "current_speed", \
	dash_handler.speed, 0.5, dash_handler.current_speed)
	
	TweenManager.create_new_tween(dash_handler, "current_duration", \
	dash_handler.duration, 0.5, dash_handler.current_duration)
	
	TweenManager.create_new_tween(dash_handler.cooldown, "wait_time", \
	dash_handler.cooldown_value, 0.5, dash_handler.cooldown.wait_time)
