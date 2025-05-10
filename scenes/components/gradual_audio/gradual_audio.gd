extends AudioStreamPlayer3D
class_name GradualAudio

@export var max_pitch := 1.3
@export var min_pitch := 1.0

func play_audio(current_value: int, max_value: int) -> void:
	if stream == null:
		return
	
	var normalized := clamp(1.0 - (float(current_value) / float(max_value)), 0.0, 1.0) as float
	pitch_scale = lerp(min_pitch, max_pitch, normalized)
	
	print("Current:", current_value, " / Max:", max_value, " -> Pitch:", pitch_scale)
	
	play()
