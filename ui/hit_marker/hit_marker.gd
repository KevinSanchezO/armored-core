extends TextureRect
class_name HitMarker

@export var timer_value := 0.2

@onready var timer := $Timer as Timer

func _ready() -> void:
	self.visible = false
	timer.wait_time = timer_value
	timer.timeout.connect(hide_hit_marker)


func show_hit_marker() -> void:
	self.visible = true
	timer.start()


func hide_hit_marker() -> void:
	self.visible = false
