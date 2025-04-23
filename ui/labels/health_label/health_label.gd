extends RichTextLabel
class_name HealthLabel

@export var string_health_value : String

@onready var timer := $Timer as Timer

var timer_value := 0.5
var points : float

func _ready() -> void:
	timer.wait_time = timer_value
	timer.timeout.connect(_reset_health_label)


func init_health_label(new_points:float) -> void:
	points = new_points
	var format_string = "%s %s"
	var actual_string = format_string% [string_health_value, _stylize_points(new_points)]
	self.text = actual_string


func damage_taken_label_update(new_points:float) -> void:
	points = new_points
	var format_string = "[color=%s]%s [shake rate=20.0 level=2 connected=1]%s[/shake][/color]"
	var actual_string = format_string% [ColorsUI.BRIGHT_RED_STR, string_health_value, _stylize_points(new_points)]
	self.text = actual_string
	timer.start()
	

func _reset_health_label() -> void:
	self.text = string_health_value + " " + _stylize_points(points)


func _stylize_points(value: float) -> String:
	var stylize_string : String
	
	var value_string := str(value)
	
	if value <= 999:
		stylize_string += "0"
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += value_string 
	
	return stylize_string
