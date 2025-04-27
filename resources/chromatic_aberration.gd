extends CanvasLayer
class_name ChromaticAberration

@export var strength_shader := 0.4

@onready var shader_color_rect := $Control/ColorRect


func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_show_chromatic_aberration)
	SlowMotion.slow_motion_ended.connect(_hide_chromatic_aberration)


func _show_chromatic_aberration() -> void:
	var tween = create_tween()
	tween.tween_method(_update_shader_strength, _get_current_strength(), strength_shader, 0.5)
	#shader_color_rect.material.set("shader_parameter/strength", 0.5)


func _hide_chromatic_aberration() -> void:
	var tween = create_tween()
	tween.tween_method(_update_shader_strength, _get_current_strength(), 0.0, 0.5)
	#shader_color_rect.material.set("shader_parameter/strength", 0)


func _update_shader_strength(value: float) -> void:
	shader_color_rect.material.set("shader_parameter/strength", value)


func _get_current_strength() -> float:
	return shader_color_rect.material.get("shader_parameter/strength")
