extends Node
class_name Health


signal died()
signal health_reduced()
signal health_increased()

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
	health_reduced.emit()
	
	if dead:
		check_death.call_deferred()


func heal(value: float) -> void:
	if dead:
		return
	
	var new_health = current_health + value
	
	if new_health >= max_health:
		current_health = max_health
	else:
		current_health = new_health
	health_increased.emit()


func get_health_percent() -> float:
	if dead:
		return 0.0
	
	return minf(current_health / max_health, 1.0)


func check_death() -> void:
	died.emit()
