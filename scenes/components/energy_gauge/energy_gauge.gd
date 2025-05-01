extends Node3D
class_name EnergyGauge

signal energy_gauge_changed()
signal cooldown_started()
signal cooldown_ended()

const MAX_ENERGY_GAUGE := 100.0

@export var consumption := 12.0
@export var recovery := 1.0
@export var consumption_timer_value := 0.05

@onready var energy_gauge := MAX_ENERGY_GAUGE
@onready var comsumption_timer := $ConsumptionTimer as Timer

var is_consuming := false
var is_in_cooldown := false

func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_energy)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_energy)
	comsumption_timer.wait_time = consumption_timer_value
	comsumption_timer.timeout.connect(_on_consumption_timer_timeout)


func _physics_process(_delta) -> void:
	if energy_gauge <= 0:
		energy_gauge = 0
		is_in_cooldown = true
		cooldown_started.emit()
	
	if energy_gauge == MAX_ENERGY_GAUGE and is_in_cooldown:
		is_in_cooldown = false


func modify_gauge_directly(value=consumption) -> void:
	energy_gauge -= value
	if energy_gauge < 0:
		energy_gauge = 0
	energy_gauge_changed.emit()


func _on_consumption_timer_timeout():
	if !is_consuming:
		if energy_gauge < MAX_ENERGY_GAUGE:
			energy_gauge += recovery
		else:
			energy_gauge = MAX_ENERGY_GAUGE
			cooldown_ended.emit()
	else:
		energy_gauge -= consumption
	energy_gauge_changed.emit()


func _enter_slow_motion_energy() -> void:
	TweenManager.create_new_tween(comsumption_timer, "wait_time",\
	consumption_timer_value / 2, 0.5, comsumption_timer.wait_time)


func _exit_slow_motion_energy() -> void:
	TweenManager.create_new_tween(comsumption_timer, "wait_time",\
	consumption_timer_value, 0.5, comsumption_timer.wait_time)
