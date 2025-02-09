extends Area3D
class_name Hurtbox

@export var damage := 0.0

signal damage_dealt
signal wall_impacted

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.body_entered.connect(_on_body_entered)

func trigger_frame() -> void:
	disable()
	await get_tree().process_frame
	await get_tree().process_frame
	enable()

func _on_area_entered(area) -> void:
	if area is Hitbox:
		area.deal_damage(damage)
		damage_dealt.emit()

func _on_body_entered(body) -> void:
	if body.get_collision_layer() == 1:
		wall_impacted.emit()

func enable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape3D and not child is CollisionPolygon3D:
			continue
		child.disabled = false

func disable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape3D and not child is CollisionPolygon3D:
			continue
		
		child.disabled = true
