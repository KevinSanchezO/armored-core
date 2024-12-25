extends Node
class_name Health


signal died()
signal health_changed()

@export var max_health := 100.0

var current_health: float
var dead: bool:
	get:
		return current_health <= 0.0


func _ready() -> void:
	current_health = max_health


func damage(value: float) -> void:
	if dead:
		return
	
	current_health = maxf(current_health - value, 0.0)
	health_changed.emit()
	
	if dead:
		check_death.call_deferred()


func get_health_percent() -> float:
	if dead:
		return 0.0
	
	return minf(current_health / max_health, 1.0)


func check_death() -> void:
	died.emit()
