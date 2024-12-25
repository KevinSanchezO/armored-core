extends Area3D
class_name Hitbox

@export var health:Health

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

func deal_damage(attack_value: float):
	if health == null:
		push_error("No health component detected")
		return
	health.damage(attack_value)
