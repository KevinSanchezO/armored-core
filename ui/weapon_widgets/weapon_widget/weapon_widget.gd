extends HBoxContainer
class_name WeaponWidget

var no_reload = false
var just_reloaded = true
var is_reloading = false
var timer_value := 0.1
var last_value_chamber: int
var last_value_ammo : int

@onready var weapon_name_label := $WeaponInfo/WeaponName as Label
@onready var rounds_label := $WeaponInfo/Rounds as RichTextLabel
@onready var timer := $Timer as Timer

func _ready() -> void:
	timer.timeout.connect(_reset_rounds_label)

func reload_handling() -> void:
	timer.stop()
	var format_string = "[color=%s][wave amp=15.0 freq=5.0 connected=1]Reloading...[/wave][/color]"
	var actual_string = format_string% [ColorsUI.BRIGHT_RED_STR]
	rounds_label.text = actual_string
	just_reloaded = true

func set_weapon_rounds(weapon:Weapon) -> void:
	var rounds_text = ""
	
	if weapon is RangeWeapon:
		if weapon.max_ammo > 0:
			var format_string:String
			var actual_string:String
			if just_reloaded:
				format_string = "%s | %s"
				actual_string = format_string % [_stylize_value(weapon.current_chamber), \
				_stylize_value(weapon.current_max_ammo)]
			else:
				format_string = "[color=%s][shake rate=20.0 level=2 connected=1]%s[/shake][/color] | %s"
				actual_string = format_string% [ColorsUI.BRIGHT_RED_STR, _stylize_value(weapon.current_chamber), \
				_stylize_value(weapon.current_max_ammo)]
				timer.start()
			rounds_text = actual_string
		else:
			no_reload = true
			if just_reloaded:
				rounds_text = _stylize_value(weapon.current_chamber)
			else:
				var format_string = "[color=%s][shake rate=20.0 level=2 connected=1]%s[/shake][/color]"
				var actual_string = format_string% [ColorsUI.BRIGHT_RED_STR, _stylize_value(weapon.current_chamber)]
				rounds_text = actual_string
				timer.start()
		last_value_chamber = weapon.current_chamber
		last_value_ammo = weapon.current_max_ammo
		rounds_label.text = rounds_text
		just_reloaded = false
	else:
		rounds_label.text = rounds_text


func set_weapon_name(weapon_name:String) -> void:
	weapon_name_label.text = weapon_name


func _reset_rounds_label() -> void:
	var rounds_text : String
	if no_reload:
		rounds_text = _stylize_value(last_value_chamber)
	else:
		var format_string = "%s | %s"
		var actual_string = format_string % [_stylize_value(last_value_chamber), \
		_stylize_value(last_value_ammo)]
		rounds_text = actual_string
	rounds_label.text = rounds_text


func _stylize_value(value:int) -> String:
	var stylize_string = ""
	
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += str(value)
	
	return stylize_string
