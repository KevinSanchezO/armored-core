extends HBoxContainer
class_name HealthInfo

@onready var armor_points_label := $HBoxContainer/VBoxContainer/ArmorPoints as Label
@onready var armor_points_bar := $HBoxContainer/VBoxContainer/ProgressBarTemplate as ProgressBarTemplate

@onready var entity_health_label := $HBoxContainer2/VBoxContainer2/EntityHealth as Label
@onready var entity_health_bar:= $HBoxContainer2/VBoxContainer2/ProgressBarTemplate as ProgressBarTemplate

func set_ready(new_armor_points, new_entity_health) -> void:
	armor_points_bar.init_value(new_armor_points)
	entity_health_bar.init_value(new_entity_health)
	
	set_new_health_info(new_armor_points, new_entity_health)


func set_new_health_info(new_armor_points, new_entity_health) -> void:
	armor_points_label.text = "AP " + _stylize_value(new_armor_points)
	entity_health_label.text = _stylize_value(new_entity_health) + " HP"
	
	armor_points_bar.value_progress_bar = new_armor_points
	entity_health_bar.value_progress_bar = new_entity_health


func _stylize_value(value)->String:
	var stylize_string := ""
	var value_string := str(value)
	
	if value <= 9999:
		stylize_string += "0"
	if value <= 999:
		stylize_string += "0"
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += value_string 
	return stylize_string
