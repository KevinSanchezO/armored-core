extends RangeWeapon
class_name MachineGun


func _process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_just_pressed("reload"):
		_reload()
	
	if Input.is_action_pressed("right_weapon") and \
	fire_rate.is_stopped():
		generate_projectile()
