extends RangeWeapon
class_name Rifle


func _process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_just_pressed("reload"):
		start_reload()
	
	if Input.is_action_just_pressed("right_weapon") and \
	fire_rate.is_stopped():
		generate_projectile()
