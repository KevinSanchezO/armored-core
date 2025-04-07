extends ReferenceRect
class_name HitMarker

var WHITE := Color.html("#ffffff")
var RED := Color.html("#cf000e")

@export var timer_value := 0.2

@onready var timer := $Timer as Timer

func _ready() -> void:
	timer.wait_time = timer_value
	timer.timeout.connect(hide_hit_marker)
	

func show_hit_marker() -> void:
	timer.start()
	_change_color(RED)

func hide_hit_marker() -> void:
	_change_color(WHITE)

func _change_color(new_color: Color) -> void:
	self.border_color = new_color

func modify_hit_marker_size(new_size:int):
	self.set_size(Vector2(new_size, new_size))
	set_anchors_preset(Control.PRESET_CENTER)
