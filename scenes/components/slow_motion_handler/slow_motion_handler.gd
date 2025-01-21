extends Node
class_name SlowMotionHandler

signal low_health_reached()
signal slow_motion_count_reached()
signal cooldown_started()
signal cooldown_ended()
signal count_updated()

const NORMAL_TIME_SCALE := 1.0
const MAX_SLOW_MOTION_GAUGE := 100.0

@export var health : Health
@export var slow_motion_time_scale := 0.5
@export var penalty := 10.0
@export var max_slow_motion_count := 2

var slow_motion_count := 0
var slow_motion_gauge : int
var consumption := 2.0
var recovery := 1.0

@onready var consumption_timer := $ConsumptionTimer as Timer
@onready var enter_audio := $Enter as Audio3D
@onready var exit_audio := $Exit as Audio3D

func _ready() -> void:
	slow_motion_gauge = MAX_SLOW_MOTION_GAUGE
	consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("slow_motion"):
		if health.current_health > penalty:
			if SlowMotion.slow_motion_active:
				_exit_slow_motion()
			else:
				if slow_motion_gauge != MAX_SLOW_MOTION_GAUGE:
					return
				_enter_slow_motion()
		else:
			low_health_reached.emit()
			
	if SlowMotion.slow_motion_active and slow_motion_gauge <= 0:
		cooldown_started.emit()
		_exit_slow_motion()


func _exit_slow_motion() -> void:
	exit_audio.play_audio()
	
	SlowMotion.slow_motion_active = false
	SlowMotion.modify_time_scale(NORMAL_TIME_SCALE, 0.5, false)


func _enter_slow_motion():
	slow_motion_count += 1
	count_updated.emit()
	
	enter_audio.play_audio()
	
	if slow_motion_count == max_slow_motion_count:
		slow_motion_count_reached.emit()
	
	if slow_motion_count > max_slow_motion_count:
		health.damage(penalty)
	
	SlowMotion.slow_motion_active = true
	SlowMotion.modify_time_scale(slow_motion_time_scale, 0.5, true)

func _on_consumption_timer_timeout() -> void:
	if SlowMotion.slow_motion_active: 
		slow_motion_gauge -= consumption
	else:
		if slow_motion_gauge < 100:
			slow_motion_gauge += recovery
		else:
			cooldown_ended.emit()
			slow_motion_gauge = MAX_SLOW_MOTION_GAUGE
