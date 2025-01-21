extends AudioStreamPlayer3D
class_name Audio3D

@export var randomize_pitch := true
@export var max_pitch := 1.1
@export var min_pitch := 0.9

func play_audio() -> void:
	if stream == null:
		return
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1
	
	play()
