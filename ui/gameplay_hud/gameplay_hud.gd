extends CanvasLayer
class_name GameplayHUD

var SAFE_BOOST_COOLOR := Color.html("#3782e7")
var DANGER_BOOST_COLOR := Color.html("#e24937")

@export var entity : Player
@export var energy_bar : EnergyBar
@export var health_info : HealthInfo

@onready var energy_gauge := $"../EnergyGauge" as EnergyGauge
@onready var armor_points := $"../HealthEntity" as Health
@onready var health_pilot := $"../HealthPilot" as Health

func _ready() -> void:
	energy_gauge.cooldown_started.connect(_on_cooldown_started)
	energy_gauge.cooldown_ended.connect(_on_cooldown_ended)

func _process(_delta) -> void:
	_update_energy_bar()
	_update_health_info()

func _update_health_info() -> void:
	health_info.set_new_health_info(armor_points.current_health, health_pilot.current_health)

func _update_energy_bar() -> void:
	energy_bar.value = energy_gauge.energy_gauge

func _on_cooldown_started() -> void:
	energy_bar.update_color(DANGER_BOOST_COLOR)

func _on_cooldown_ended() -> void:
	energy_bar.update_color(SAFE_BOOST_COOLOR)
	