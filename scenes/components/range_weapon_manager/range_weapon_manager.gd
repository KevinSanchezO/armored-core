extends Node3D
class_name RangeWeaponManager

signal weapon_changed()

const MAX_NUMBER_WEAPONS := 2

@export var entity : Player
@export var raycast_range_weapons : RaycastRangeWeapon

var active_weapon : RangeWeapon
var available_weapons := []

func _ready() -> void:
	_load_weapons()


func _load_weapons() -> void:
	if RangeWeaponLoad.available_weapons.size() < 1:
		push_error('No weapons to load')
	
	for weapon_to_load in RangeWeaponLoad.available_weapons:
		var weapon_scene := load(weapon_to_load) as PackedScene
		var weapon_instance := weapon_scene.instantiate() as Weapon
		available_weapons.append(weapon_instance)
		self.add_child(weapon_instance) 
		weapon_instance.global_position = self.global_position
		
		weapon_instance.entity = entity
		weapon_instance.raycast_range_weapon = raycast_range_weapons
		weapon_instance.visible = false
		print(weapon_instance)

	active_weapon = available_weapons[0]
	active_weapon.activate_weapon()
	active_weapon.visible = true


func switch_weapon() -> void:
	if available_weapons.size() == 1 or available_weapons.size() == 0:
		return
	
	if not active_weapon.can_change and active_weapon.firing:
		return
	
	var previous_weapon = active_weapon
	if previous_weapon == available_weapons[0]:
		active_weapon = available_weapons[1]
	else:
		active_weapon = available_weapons[0]
	
	previous_weapon.visible = false
	previous_weapon.active = false
	
	active_weapon.visible = true
	active_weapon.activate_weapon()
	weapon_changed.emit()
