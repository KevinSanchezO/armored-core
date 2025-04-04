extends CanvasLayer
class_name GameplayUI

var SAFE_ENERGY_COLOR := Color.html("#ffffff")
var DANGER_ENERGY_COLOR := Color.html("#e24937")

var entity : Player

var energy_gauge : EnergyGauge
var armor_points : Health
var health_pilot : Health
var slow_motion_handler : SlowMotionHandler

@onready var health_info := $MarginContainer/Control/HBoxContainer/HealthInfo as HealthInfo
@onready var energy_n_slowmotion := $MarginContainer/Control/HBoxContainer/EnergyNSlowmotion as EnergyNSlowmotion
@onready var hit_marker :=  $MarginContainer/Control/HitMarker as HitMarker

func _ready() -> void:
	gameplay_ui_config.call_deferred()
	HitMark.hit_mark_showed.connect(_show_hitmarker)


func gameplay_ui_config() -> void:
	entity = get_tree().get_first_node_in_group("player")
	
	energy_gauge = entity.energy_gauge
	armor_points = entity.health_entity
	health_pilot = entity.health_pilot
	slow_motion_handler = entity.slow_motion_handler
	
	health_info.set_ready(armor_points.max_health, health_pilot.max_health)
	health_pilot.health_reduced.connect(_update_health_info)
	armor_points.health_reduced.connect(_update_health_info)
	
	energy_n_slowmotion.set_ready(energy_gauge.energy_gauge, slow_motion_handler.slow_motion_gauge,\
	slow_motion_handler.max_slow_motion_count)
	
	energy_gauge.cooldown_started.connect(_energy_cooldown_started)
	energy_gauge.cooldown_ended.connect(_energy_cooldown_ended)
	
	slow_motion_handler.cooldown_started.connect(_slowmotion_cooldown_started)
	slow_motion_handler.cooldown_ended.connect(_slowmotion_cooldown_ended)
	slow_motion_handler.count_updated.connect(_slowmotion_update_count)

func _show_hitmarker() -> void:
	hit_marker.show_hit_marker()

func _process(_delta) -> void:
	energy_n_slowmotion.update_bars_mirror(energy_gauge.energy_gauge, slow_motion_handler.slow_motion_gauge)

func _update_health_info() -> void:
	health_info.set_new_health_info(armor_points.current_health, health_pilot.current_health)

func _energy_cooldown_started() -> void:
	energy_n_slowmotion.update_energy_bar_color(DANGER_ENERGY_COLOR)

func _energy_cooldown_ended() -> void:
	energy_n_slowmotion.update_energy_bar_color(SAFE_ENERGY_COLOR)

func _slowmotion_cooldown_started() -> void:
	energy_n_slowmotion.update_slowmotion_bar_color(DANGER_ENERGY_COLOR)

func _slowmotion_cooldown_ended() -> void:
	energy_n_slowmotion.update_slowmotion_bar_color(SAFE_ENERGY_COLOR)

func _slowmotion_update_count() -> void:
	energy_n_slowmotion.set_current_slow_motion_count()
	energy_n_slowmotion.update_slow_motion_label()
