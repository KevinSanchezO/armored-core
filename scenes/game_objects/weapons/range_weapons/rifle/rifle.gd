extends RangeWeapon
class_name Rifle

const BURST_SHOOTS := 4

func _physics_process(delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_just_pressed("reload"):
		start_reload()
	
	if Input.is_action_just_pressed("right_weapon") and \
	fire_rate.is_stopped():
		_burst_fire()
		


func _burst_fire() -> void:
	for i in BURST_SHOOTS:
		generate_projectile()
		await get_tree().create_timer(fire_rate.wait_time/BURST_SHOOTS).timeout
