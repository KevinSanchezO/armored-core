extends HBoxContainer
class_name WeaponWidget



@onready var weapon_name_label := $WeaponInfo/WeaponName as Label
@onready var rounds_label := $WeaponInfo/Rounds as Label


func reload_handling() -> void:
	rounds_label.text = "Reloading..."

func set_weapon_rounds(weapon:Weapon) -> void:
	var rounds_text = ""
	
	if weapon is RangeWeapon:
		var format_string = "%s  |  %s"
		var actual_string = format_string % [str(weapon.current_chamber), str(weapon.current_max_ammo)]
		rounds_text = actual_string
		
	rounds_label.text = rounds_text

func set_weapon_name(weapon_name:String) -> void:
	weapon_name_label.text = weapon_name
