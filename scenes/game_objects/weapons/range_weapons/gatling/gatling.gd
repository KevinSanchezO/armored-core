extends RangeWeapon
class_name Gatling

var active_shooting := false

func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if current_chamber == 0 and current_max_ammo == 0:
		return
	
	if Input.is_action_pressed("left_weapon") and !active_shooting and active and \
	reload_timer.is_stopped():
		active_shooting = true
	
	if current_chamber != 0 and active_shooting and fire_rate.is_stopped() and active:
		generate_projectile()
	
	if current_chamber == 0 and active_shooting and current_max_ammo != 0:
		active_shooting = false
		start_reload()
