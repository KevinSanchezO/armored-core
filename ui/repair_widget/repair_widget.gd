extends VBoxContainer
class_name RepairWidget


@onready var repair_label := $RepairLabel as Label
@onready var repair_count_label := $RepairRectangle/RepairsCountLabel as Label

func modify_repair_count(new_value:int) -> void:
	var color := ColorsUI.WHITE if new_value > 0 else ColorsUI.RED
	
	repair_count_label.text = str(new_value)
	repair_count_label.set("theme_override_colors/font_color", color)
