extends CanvasLayer
class_name Glitch

@onready var color_rect := $Control/ColorRect as ColorRect
@onready var timer := $Timer as Timer

@export var timer_value := 0.2
@export var armor_points : Health
@export var health_points : Health

func _ready() -> void:
	color_rect.visible = false
	
	armor_points.health_reduced.connect(_show)
	health_points.health_reduced.connect(_show)
	
	timer.wait_time = timer_value
	timer.timeout.connect(_hide)

func _show() -> void:
	color_rect.visible = true
	timer.start()

func _hide() -> void:
	color_rect.visible = false
