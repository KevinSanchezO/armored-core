extends RangeWeapon
class_name Gatling

@export var sleep_timer_value := 5.0

@onready var sleep_timer := $SleepTimer as Timer

var active_shooting := false

func _ready() -> void:
	super()
	sleep_timer.wait_time = sleep_timer_value

func _process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_pressed("left_weapon") and !active_shooting:
		active_shooting = true
	
	if current_chamber != 0 and active_shooting and fire_rate.is_stopped() and \
	sleep_timer.is_stopped():
		generate_projectile()
	
	if current_chamber == 0:
		active_shooting = false
		sleep_timer.start()
		_reload()
