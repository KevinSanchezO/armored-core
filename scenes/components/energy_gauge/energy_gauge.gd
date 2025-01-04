extends Node
class_name EnergyGauge

signal energy_gauge_changed()
signal cooldown_started()
signal cooldown_ended()

const MAX_ENERGY_GAUGE := 100.0

@export var consumption := 12.0
@export var recovery := 1.0

@onready var energy_gauge := MAX_ENERGY_GAUGE
@onready var comsumption_timer := $ConsumptionTimer as Timer

var is_consuming := false
var is_in_cooldown := false

func _ready() -> void:
	comsumption_timer.timeout.connect(_on_consumption_timer_timeout)


func _process(_delta) -> void:
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
