extends MeshInstance3D
class_name SpeedLines

var material_speed_lines : Material

func _ready() -> void:
	self.visible = false
	material_speed_lines = get_surface_override_material(0)


func show_speed_lines() -> void:
	material_speed_lines.set('shader_parameter/line_color.a', 127)
	self.visible = true


func hide_speed_lines() -> void:
	self.visible = false
