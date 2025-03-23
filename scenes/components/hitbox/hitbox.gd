extends Area3D
class_name Hitbox

@export var health:Health

@export_range(0.1, 0.8, 0.1) var blunt_defense := 0.1
@export_range(0.1, 0.8, 0.1) var energy_defense := 0.1
@export_range(0.1, 0.8, 0.1) var explosion_defense := 0.1

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
