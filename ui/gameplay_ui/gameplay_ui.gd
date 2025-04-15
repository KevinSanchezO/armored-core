extends CanvasLayer
class_name GameplayUI

var SAFE_ENERGY_COLOR := Color.html("#ffffff")
var DANGER_ENERGY_COLOR := Color.html("#e24937")
var WARNING_SLOWMO_COLOR := Color.html("#f4c94d")

var entity : Player

var energy_gauge : EnergyGauge
var armor_points : Health
var health_pilot : Health
var slow_motion_handler : SlowMotionHandler

@onready var hit_marker := $MarginContainer/Control/CentralContainer/HitMarkerContainer/HitMarker as HitMarker
@onready var energy_bar := $MarginContainer/Control/CentralContainer/ProgressBarEnergy as ProgressBarTemplate
@onready var slow_motion_bar := $MarginContainer/Control/CentralContainer/ProgressBarSlowMotion as ProgressBarTemplate


func _ready() -> void:
	gameplay_ui_config.call_deferred()
	HitMark.hit_mark_showed.connect(hit_marker.show_hit_marker)


func _process(_delta) -> void:
	energy_bar.value_progress_bar = energy_gauge.energy_gauge
	slow_motion_bar.value_progress_bar = slow_motion_handler.slow_motion_gauge


func gameplay_ui_config() -> void:
	entity = get_tree().get_first_node_in_group("player")
	
	energy_gauge = entity.energy_gauge
	armor_points = entity.health_entity
	health_pilot = entity.health_pilot
	slow_motion_handler = entity.slow_motion_handler
	
	energy_bar.init_value(energy_gauge.energy_gauge)
	slow_motion_bar.init_value(slow_motion_handler.slow_motion_gauge)
	
	energy_gauge.cooldown_started.connect(_energy_cooldown_started)
	energy_gauge.cooldown_ended.connect(_energy_cooldown_ended)
	
	slow_motion_handler.cooldown_started.connect(_slowmotion_cooldown_started)
	slow_motion_handler.cooldown_ended.connect(_slowmotion_cooldown_ended)
	
	entity.range_weapon_manager.weapon_changed.connect(_handle_hit_marker_change)
	_handle_hit_marker_change()


func _energy_cooldown_started() -> void:
	energy_bar.update_color(DANGER_ENERGY_COLOR)


func _energy_cooldown_ended() -> void:
	energy_bar.update_color(SAFE_ENERGY_COLOR)


func _slowmotion_cooldown_started() -> void:
	slow_motion_bar.update_color(DANGER_ENERGY_COLOR)


func _slowmotion_cooldown_ended() -> void:
	var reached_limit := slow_motion_handler.slow_motion_count >= slow_motion_handler.max_slow_motion_count
	
	var color := SAFE_ENERGY_COLOR if !reached_limit else WARNING_SLOWMO_COLOR
	slow_motion_bar.update_color(color)


func _handle_hit_marker_change() -> void:
	hit_marker.set_size_hit_marker(entity.range_weapon_manager.active_weapon.hit_marker_size)
