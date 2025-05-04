extends RangeWeapon
class_name RailCannon


func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if current_chamber == 0 and current_max_ammo == 0:
		return
	
	if Input.is_action_pressed("left_weapon") and active and \
	reload_timer.is_stopped():
		generate_projectile()
	
	if current_chamber == 0 and current_max_ammo != 0:
		start_reload()
