extends CanvasLayer
class_name GameplayUI

var entity : Player

var energy_gauge : EnergyGauge
var armor_points : Health
var health_points : Health
var slow_motion_handler : SlowMotionHandler
var primary_weapon_manager : PrimaryWeaponManager
var support_weapon_manager : SupportWeaponManager

@onready var hit_marker := %HitMarker as HitMarker
@onready var energy_bar := %ProgressBarEnergy as ProgressBarTemplate
@onready var slow_motion_bar := %ProgressBarSlowMotion as ProgressBarTemplate
@onready var repair_widget := %RepairWidget as RepairWidget
@onready var health_points_label := %LabelHealthPoints as HealthLabel
@onready var health_points_bar := %ProgressBarHealthPoints as ProgressBarMirror
@onready var armor_points_label := %LabelArmorPoints as HealthLabel
@onready var armor_points_bar := %ProgressBarArmorPoints as ProgressBarMirror
@onready var weapon_widget_1 := %WeaponWidget1 as WeaponWidget
@onready var weapon_widget_2 := %WeaponWidget2 as WeaponWidget
@onready var weapon_widget_support := %SupportWeapon as WeaponWidget

func _ready() -> void:
	gameplay_ui_config.call_deferred()
	HitMark.hit_mark_showed.connect(hit_marker.show_hit_marker)


func _physics_process(_delta: float) -> void:
	if energy_gauge != null and slow_motion_handler != null:
		energy_bar.value_progress_bar = energy_gauge.energy_gauge
		slow_motion_bar.value_progress_bar = slow_motion_handler.slow_motion_gauge


func gameplay_ui_config() -> void:
	entity = get_tree().get_first_node_in_group("player")
	
	energy_gauge = entity.energy_gauge
	armor_points = entity.armor_points
	health_points = entity.health_points
	slow_motion_handler = entity.slow_motion_handler
	primary_weapon_manager = entity.primary_weapon_manager
	support_weapon_manager = entity.support_weapon_manager
	
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
	health_points_label.init_health_label(health_points.current_health)
	health_points.health_reduced.connect(_update_health_points)
	
	# armor points progress bar
	armor_points_bar.init_progress_bar_mirror(armor_points.current_health)
	armor_points_label.init_health_label(armor_points.current_health)
	armor_points.health_reduced.connect(_update_armor_points)

	# hit marker
	entity.primary_weapon_manager.weapon_changed.connect(_handle_hit_marker_change)
	_handle_hit_marker_change()
	
	#primary weapons
	_init_weapon_widget(weapon_widget_1, primary_weapon_manager.available_weapons[0])
	if primary_weapon_manager.available_weapons[0] is RangeWeapon:
		
		primary_weapon_manager.available_weapons[0].chamber_modified.connect(\
		Callable(_update_weapon_widget).bind(weapon_widget_1, \
		primary_weapon_manager.available_weapons[0]))
		
		primary_weapon_manager.available_weapons[0].reload_started.connect(\
		Callable(_reload).bind(weapon_widget_1))
	
	if primary_weapon_manager.available_weapons.size() > 1:
		_init_weapon_widget(weapon_widget_2, primary_weapon_manager.available_weapons[1])
		if primary_weapon_manager.available_weapons[1] is RangeWeapon:
			
			primary_weapon_manager.available_weapons[1].chamber_modified.connect(
			Callable(_update_weapon_widget).bind(weapon_widget_2, \
			primary_weapon_manager.available_weapons[1])) 
			
			primary_weapon_manager.available_weapons[1].reload_started.connect(\
			Callable(_reload).bind(weapon_widget_2))
	
	#support weapons
	if support_weapon_manager.active_weapon != null:
		_init_weapon_widget(weapon_widget_support, support_weapon_manager.active_weapon)
		if support_weapon_manager.active_weapon is RangeWeapon:
			
			support_weapon_manager.active_weapon.chamber_modified.connect(
			Callable(_update_weapon_widget).bind(weapon_widget_support, \
			support_weapon_manager.active_weapon)) 
			
			support_weapon_manager.active_weapon.reload_started.connect(\
			Callable(_reload).bind(weapon_widget_support))


func _energy_cooldown_started() -> void:
	energy_bar.update_color(ColorsUI.RED)


func _energy_cooldown_ended() -> void:
	energy_bar.update_color(ColorsUI.WHITE)


func _slowmotion_cooldown_started() -> void:
	slow_motion_bar.update_color(ColorsUI.RED)


func _slowmotion_cooldown_ended() -> void:
	var reached_limit := slow_motion_handler.slow_motion_count >= slow_motion_handler.max_slow_motion_count
	
	var color := ColorsUI.WHITE if !reached_limit else ColorsUI.YELLOW
	slow_motion_bar.update_color(color)


func _update_repair_widget() -> void:
	repair_widget.modify_repair_count(entity.repair_handler.repairs_left)


func _update_health_points() -> void:
	health_points_bar.update_value_bar_mirror(health_points.current_health)
	health_points_label.damage_taken_label_update(health_points.current_health)


func _update_armor_points() -> void:
	armor_points_bar.update_value_bar_mirror(armor_points.current_health)
	armor_points_label.damage_taken_label_update(armor_points.current_health)


func _handle_hit_marker_change() -> void:
	hit_marker.set_size_hit_marker(entity.primary_weapon_manager.active_weapon.hit_marker_size)


func _init_weapon_widget(widget: WeaponWidget, weapon:Weapon) -> void:
	widget.set_weapon_name(weapon.weapon_name)
	widget.set_weapon_rounds(weapon)


func _update_weapon_widget(widget: WeaponWidget, weapon:Weapon) -> void:
	widget.set_weapon_rounds(weapon)


func _reload(widget: WeaponWidget) -> void:
	widget.reload_handling()
