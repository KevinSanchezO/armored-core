extends Camera3D
class_name GameCamera

const TRAUMA_REDUCTION_RATE = 1.0

@onready var initial_rotation := self.rotation_degrees as Vector3
@onready var current_trauma_reduction_rate = TRAUMA_REDUCTION_RATE

@export var noise : FastNoiseLite
@export var noise_speed := 50.0
@export var max_x := 16.0
@export var max_y := 8.0
@export var max_z := 16.0

var trauma := 0.0 #between 0 and 1
var time := 0.0

func _ready() -> void:
	Camera.camera = self
	SlowMotion.slow_motion_started.connect(_on_slow_motion_entered)
	SlowMotion.slow_motion_ended.connect(_on_slow_motion_ended)


func _process(delta) -> void:
	time += delta
	trauma = max(trauma - delta * current_trauma_reduction_rate, 0.0)
	
	self.rotation_degrees.x = initial_rotation.x + max_x * \
	_get_shake_intensity() * _get_noise_from_seed(0)
	
	self.rotation_degrees.y = initial_rotation.y + max_y * \
	_get_shake_intensity() * _get_noise_from_seed(1)
	
	#self.rotation_degrees.z = initial_rotation.z + max_z * \
	#_get_shake_intensity() * _get_noise_from_seed(2)

func add_trauma(trauma_ammount: float) -> void:
	trauma = clamp(trauma + trauma_ammount, 0.0, 1.0)


func _get_shake_intensity() -> float:
	return trauma * trauma


func _get_noise_from_seed(_seed: int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)


func _on_slow_motion_entered() -> void:
	return


func _on_slow_motion_ended() -> void:
	return
