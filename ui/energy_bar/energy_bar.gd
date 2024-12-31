extends ProgressBar
class_name EnergyBar

func update_color(new_color:Color) -> void:
	var stylebox_flat = self.get_theme_stylebox("fill", "ProgressBar")
	stylebox_flat.bg_color = new_color
	self.add_theme_stylebox_override("fill", stylebox_flat)
