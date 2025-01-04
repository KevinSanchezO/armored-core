extends CanvasLayer
class_name GameplayHUD

var SAFE_BOOST_COOLOR := Color.html("#3782e7")
var DANGER_BOOST_COLOR := Color.html("#e24937")

var SAFE_SLOWMOTION_COLOR := Color.html("#ffffff")
var SAFE_SLOWMOTION_LIMIT_COLOR := Color.html("#d8e75d")
var DANGER_SLOWMOTION_COLOR := Color.html("#e24937")

@export var entity : Player

@onready var current_safe_color := SAFE_SLOWMOTION_COLOR
 
@onready var energy_gauge := $"../EnergyGauge" as EnergyGauge
@onready var armor_points := $"../HealthEntity" as Health
@onready var health_pilot := $"../HealthPilot" as Health
@onready var slow_motion_handler := $"../SlowMotionHandler" as SlowMotionHandler

@onready var energy_bar := $MarginContainer/Control/HBoxContainer/EnergyBar as EnergyBar
@onready var slow_motion_bar := $MarginContainer/Control/HBoxContainer/VBoxContainer/SlowMotionBar as SlowMotionBar
@onready var health_info := $MarginContainer/Control/HBoxContainer/VBoxContainer/HealthInfo as HealthInfo


func _ready() -> void:
	energy_gauge.cooldown_started.connect(_on_cooldown_energy_started)
	energy_gauge.cooldown_ended.connect(_on_cooldown_energy_ended)
	
	slow_motion_handler.cooldown_started.connect(_on_cooldown_slow_motion_started)
	slow_motion_handler.cooldown_ended.connect(_on_cooldown_slow_motion_ended)
	slow_motion_handler.slow_motion_count_reached.connect(_update_slow_motion_color)

func _process(_delta) -> void:
	_update_energy_bar()
	_update_health_info()
	_update_slow_motion_bar()

func _update_slow_motion_bar():
	slow_motion_bar.value = slow_motion_handler.slow_motion_gauge

func _update_health_info() -> void:
	health_info.set_new_health_info(armor_points.current_health, health_pilot.current_health)

func _update_energy_bar() -> void:
	energy_bar.value = energy_gauge.energy_gauge

func _update_slow_motion_color() -> void:
	current_safe_color = SAFE_SLOWMOTION_LIMIT_COLOR

func _on_cooldown_energy_started() -> void:
	energy_bar.update_color(DANGER_BOOST_COLOR)

func _on_cooldown_energy_ended() -> void:
	energy_bar.update_color(SAFE_BOOST_COOLOR)

func _on_cooldown_slow_motion_started() -> void:
	slow_motion_bar.update_color(DANGER_SLOWMOTION_COLOR)

func _on_cooldown_slow_motion_ended() -> void:
	slow_motion_bar.update_color(current_safe_color)
