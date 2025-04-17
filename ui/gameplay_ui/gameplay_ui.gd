extends CanvasLayer
class_name GameplayUI

var SAFE_ENERGY_COLOR := Color.html("#ffffff")
var DANGER_ENERGY_COLOR := Color.html("#e24937")
var WARNING_SLOWMO_COLOR := Color.html("#f4c94d")

var entity : Player

var energy_gauge : EnergyGauge
var armor_points : Health
var health_points : Health
var slow_motion_handler : SlowMotionHandler

@onready var hit_marker := $MarginContainer/Control/CentralContainer/HitMarkerContainer/HitMarker as HitMarker
@onready var energy_bar := $MarginContainer/Control/CentralContainer/ProgressBarEnergy as ProgressBarTemplate
@onready var slow_motion_bar := $MarginContainer/Control/CentralContainer/ProgressBarSlowMotion as ProgressBarTemplate
@onready var repair_widget := $MarginContainer/Control/GeneralInfo/HealthContainer/RepairWidget as RepairWidget
@onready var health_points_label := $MarginContainer/Control/GeneralInfo/HealthContainer/HealthInfoContainer/LabelHealthPoints as Label
@onready var health_points_bar := $MarginContainer/Control/GeneralInfo/HealthContainer/HealthInfoContainer/ProgressBarHealthPoints as ProgressBarMirror
@onready var armor_points_label := $MarginContainer/Control/GeneralInfo/HealthContainer/HealthInfoContainer/LabelArmorPoints as Label
@onready var armor_points_bar := $MarginContainer/Control/GeneralInfo/HealthContainer/HealthInfoContainer/ProgressBarArmorPoints as ProgressBarMirror


func _ready() -> void:
	gameplay_ui_config.call_deferred()
	HitMark.hit_mark_showed.connect(hit_marker.show_hit_marker)


func _process(_delta) -> void:
	energy_bar.value_progress_bar = energy_gauge.energy_gauge
	slow_motion_bar.value_progress_bar = slow_motion_handler.slow_motion_gauge


func gameplay_ui_config() -> void:
	entity = get_tree().get_first_node_in_group("player")
	
	energy_gauge = entity.energy_gauge
	armor_points = entity.armor_points
	health_points = entity.health_points
	slow_motion_handler = entity.slow_motion_handler
	
	# energy progress bar
	energy_bar.init_value(energy_gauge.energy_gauge)
	energy_gauge.cooldown_started.connect(_energy_cooldown_started)
	energy_gauge.cooldown_ended.connect(_energy_cooldown_ended)
	
	# slow motion progress bar
	slow_motion_bar.init_value(slow_motion_handler.slow_motion_gauge)
	slow_motion_handler.cooldown_started.connect(_slowmotion_cooldown_started)
	slow_motion_handler.cooldown_ended.connect(_slowmotion_cooldown_ended)
	
	# repair
	repair_widget.modify_repair_count(entity.repair_handler.max_repairs)
	entity.repair_handler.repair_executed.connect(_update_repair_widget)
	
	# health mirror progress bar
	health_points_bar.init_progress_bar_mirror(health_points.current_health)
	health_points_label.text = _stylize_health_points_text(health_points.current_health)
	health_points.health_reduced.connect(_update_health_points)
	
	# armor points progress bar
	armor_points_bar.init_progress_bar_mirror(armor_points.current_health)
	armor_points_label.text = _stylize_armor_points_text(armor_points.current_health)
	armor_points.health_reduced.connect(_update_armor_points)

	# hit marker
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


func _update_repair_widget() -> void:
	repair_widget.modify_repair_count(entity.repair_handler.repairs_left)


func _stylize_health_points_text(value:float) -> String:
	var stylize_string := "HP "
	
	var value_string := str(value)
	
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += value_string 
	
	return stylize_string


func _update_health_points() -> void:
	health_points_bar.update_value_bar_mirror(health_points.current_health)
	health_points_label.text = _stylize_health_points_text(health_points.current_health)


func _stylize_armor_points_text(value: float) -> String:
	var stylize_string := "AP "
	
	var value_string := str(value)
	
	
	if value <= 999:
		stylize_string += "0"
	if value <= 99:
		stylize_string += "0"
	if value <= 9:
		stylize_string += "0"
	
	stylize_string += value_string 
	
	return stylize_string


func _update_armor_points() -> void:
	armor_points_bar.update_value_bar_mirror(armor_points.current_health)
	armor_points_label.text = _stylize_armor_points_text(armor_points.current_health)


func _handle_hit_marker_change() -> void:
	hit_marker.set_size_hit_marker(entity.range_weapon_manager.active_weapon.hit_marker_size)
