extends Node
class_name EnergyGauge

signal energy_gauge_changed()

const MAX_ENERGY_GAUGE := 100.0

@export var consumption := 8.0
@export var recovery := 1.5

@onready var energy_gauge := MAX_ENERGY_GAUGE

var is_consuming := false
var is_in_cooldown := false


func _process(_delta) -> void:
	if energy_gauge <= 0:
		is_in_cooldown = true
	
	if energy_gauge == MAX_ENERGY_GAUGE and is_in_cooldown:
		is_in_cooldown = false


func modify_gauge_directly(value=consumption) -> void:
	energy_gauge -= value
	if energy_gauge < 0:
		energy_gauge = 0
	energy_gauge_changed.emit()


func _on_timer_timeout():
	if !is_consuming:
		if energy_gauge < MAX_ENERGY_GAUGE:
			energy_gauge += recovery
		else:
			energy_gauge = MAX_ENERGY_GAUGE
	else:
		energy_gauge -= consumption
	energy_gauge_changed.emit()
