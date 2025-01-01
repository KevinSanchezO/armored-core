extends Node

func frame_freeze(duration:float) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	
	if SlowMotion.slow_motion_active:
		Engine.time_scale = SlowMotion.current_engine_scale
	else:
		Engine.time_scale = 1
