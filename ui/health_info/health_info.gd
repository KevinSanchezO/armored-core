extends VBoxContainer
class_name HealthInfo

@onready var armor_points_label := $ArmorPoints as Label
@onready var entity_health_label := $EntityHealth as Label

func set_new_health_info(new_armor_points, new_entity_health) -> void:
	armor_points_label.text = "AP " + str(new_armor_points) + ".0"
	entity_health_label.text = str(new_entity_health) + ".0"
