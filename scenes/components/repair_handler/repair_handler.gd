extends Node
class_name RepairHandler

signal repair_executed
signal repair_ready
signal repair_emptied

@onready var timer := $Timer as Timer

@export var max_repairs : int
@export var repair_value : float

@export var repair_cost : float

@export var armor_points : Health
@export var health_points : Health

var repairs_left : int


func _ready() -> void:
	repairs_left = max_repairs
	timer.timeout.connect(_repair_ready)


func execute_repair() -> void:
	if repairs_left == 0:
		repair_emptied.emit()
		return
	
	repairs_left -= 1
	timer.start()
	repair_executed.emit()


func check_repair_availability() -> bool:
	return true


func _repair_ready() -> void:
	repair_ready.emit()
