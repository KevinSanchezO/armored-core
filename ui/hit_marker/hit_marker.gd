extends ReferenceRect
class_name HitMarker


@export var timer_value := 0.2
@export var display_size := 192

@onready var timer := $Timer as Timer

func _ready() -> void:
	timer.wait_time = timer_value
	timer.timeout.connect(hide_hit_marker)

func show_hit_marker() -> void:
	timer.start()
	_change_color(ColorsUI.RED)

func hide_hit_marker() -> void:
	_change_color(ColorsUI.WHITE_TRANSPARENT)

func _change_color(new_color: Color) -> void:
	self.border_color = new_color

func set_size_hit_marker(new_size: int) -> void:
	var pos := (display_size - new_size)/2
	self.set_size(Vector2(new_size, new_size))
	self.position = Vector2(pos, pos)
