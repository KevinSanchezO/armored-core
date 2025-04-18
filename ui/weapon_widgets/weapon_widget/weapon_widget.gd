extends HBoxContainer
class_name WeaponWidget



@onready var weapon_name_label := $WeaponInfo/WeaponName as Label
@onready var rounds_label := $WeaponInfo/Rounds as Label


func reload_handling() -> void:
	rounds_label.text = "Reloading..."


func set_weapon_name(weapon_name:String) -> void:
	weapon_name_label.text = weapon_name
