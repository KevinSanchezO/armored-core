extends Area3D
class_name Hitbox

signal damage_received
signal damage_memory_reset
signal damage_memory_update
signal limit_damage_memory_reached

@onready var damage_memory_timer := $Timer as Timer

@export var health : Health

@export_group("Memory Damage")
@export var damage_memory_value := 2.5
@export var damage_memory_limit := 500.0

@export_group("Defense Values")
@export_range(0.1, 0.8, 0.1) var blunt_defense := 0.1
@export_range(0.1, 0.8, 0.1) var energy_defense := 0.1
@export_range(0.1, 0.8, 0.1) var explosion_defense := 0.1

var current_damage_memory : float
var reached_memory_limit : bool :
	set(value):
		if value == true:
			_damage_memory_timeout()

func _ready() -> void:
	damage_memory_timer.wait_time = damage_memory_value
	damage_memory_timer.timeout.connect(_damage_memory_timeout)

func trigger_frame() -> void:
	disable()
	await get_tree().process_frame
	await get_tree().process_frame
	enable()

func enable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape2D and not child is CollisionPolygon2D:
			continue
		
		child.disabled = false

func disable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape2D and not child is CollisionPolygon2D:
			continue
		
		child.disabled = true

func deal_damage(attack_value: float, damage_type: String):
	if health == null:
		push_error("No health component detected")
		return
	
	if damage_type == "BLUNT":
		attack_value = attack_value - (attack_value * blunt_defense)
	if damage_type == "ENERGY":
		attack_value = attack_value - (attack_value * energy_defense)
	if damage_type == "EXPLOSION":
		attack_value = attack_value - (attack_value * explosion_defense)
	
	health.damage(attack_value)
	if !reached_memory_limit:
		_update_damage_memory(attack_value)
	damage_received.emit()

func _update_damage_memory(attack_value:float):
	if current_damage_memory + attack_value >= damage_memory_limit:
		current_damage_memory = damage_memory_limit
		damage_memory_update.emit()
		reached_memory_limit = true
	else:
		current_damage_memory += attack_value
		damage_memory_update.emit()

func _damage_memory_timeout() -> void:
	current_damage_memory = 0
	reached_memory_limit = false
	damage_memory_reset.emit()
