extends Node

var camera : GameCamera

func apply_screen_shake(trauma:float) -> void:
	if camera == null:
		return
	
	camera.add_trauma(trauma)
