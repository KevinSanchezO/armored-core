extends CanvasLayer
class_name ChromaticAberration

@onready var shader_color_rect := $Control/ColorRect


func _ready() -> void:
	shader_color_rect.visible = false
	SlowMotion.slow_motion_started.connect(_show_chromatic_aberration)
	SlowMotion.slow_motion_ended.connect(_hide_chromatic_aberration)


func _show_chromatic_aberration() -> void:
	shader_color_rect.visible = true


func _hide_chromatic_aberration() -> void:
	shader_color_rect.visible = false
