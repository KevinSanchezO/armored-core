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
		var actual_string = format_string % [_stylize_value(weapon.current_chamber), \
		_stylize_value(weapon.current_max_ammo)]
		
		rounds_text = actual_string
		
	rounds_label.text = rounds_text

func set_weapon_name(weapon_name:String) -> void:
	weapon_name_label.text = weapon_name


func _stylize_value(value:int) -> String:
	var stylize_string = ""
	
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += str(value)
	
	return stylize_string
