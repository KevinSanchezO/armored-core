extends VBoxContainer
class_name RepairWidget

var SAFE_COLOR := Color.html("#ffffff")
var DANGER_COLOR := Color.html("#e24937")

@onready var repair_label := $RepairLabel as Label
@onready var repair_count_label := $RepairRectangle/RepairsCountLabel as Label

func modify_repair_count(new_value:int) -> void:
	var color := SAFE_COLOR if new_value > 0 else DANGER_COLOR
	
	repair_count_label.text = str(new_value)
	repair_count_label.add_theme_color_override("theme_override_colors/font_color", color)
