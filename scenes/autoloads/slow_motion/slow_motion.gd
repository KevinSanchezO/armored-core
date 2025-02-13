extends Node

signal slow_motion_started()
signal slow_motion_ended()

@onready var standar_audio_value := AudioServer.playback_speed_scale
@onready var slow_motion_audio_value := AudioServer.playback_speed_scale / 2.0

var current_engine_scale := Engine.time_scale as float
var slow_motion_active : bool

func modify_time_scale(slow_motion_time_scale, slow_motion_time, slow_motion) -> void:
	slow_motion_active = slow_motion
	
	var tween_slow_motion := get_tree().create_tween() as Tween
	var tween_audio := get_tree().create_tween() as Tween
	
	if slow_motion:
		tween_audio.tween_property(AudioServer, "playback_speed_scale", 
		slow_motion_audio_value, slow_motion_time).from(AudioServer.playback_speed_scale)
		
		slow_motion_started.emit()
	else:
		tween_audio.tween_property(AudioServer, "playback_speed_scale", 
		standar_audio_value, slow_motion_time).from(AudioServer.playback_speed_scale)
		
		slow_motion_ended.emit()
	
	tween_slow_motion.tween_property(Engine, "time_scale", 
	slow_motion_time_scale, slow_motion_time).from(Engine.time_scale)
	
	current_engine_scale = slow_motion_time
	Engine.time_scale = current_engine_scale
