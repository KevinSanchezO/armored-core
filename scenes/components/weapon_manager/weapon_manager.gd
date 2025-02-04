extends Node3D
class_name WeaponManager

const MAX_NUMBER_WEAPONS := 2

@export var entity : Entity

var active_weapon : Weapon
var available_weapons := []

func _ready() -> void:
	for weapon_to_load in WeaponLoad.available_weapons:
		var weapon_scene := load(weapon_to_load) as PackedScene
		var weapon_instance := weapon_scene.instantiate() as Weapon
		available_weapons.append(weapon_instance)
		self.add_child(weapon_instance) 
		weapon_instance.global_position = self.global_position
		
		#weapon_instance.entity = entity
		weapon_instance.visible = false

	active_weapon = available_weapons[0]
	active_weapon.active = true
	active_weapon.visible = true


func switch_weapon() -> void:
	if available_weapons.size() == 1 or available_weapons.size() == 0:
		return
	
	if not active_weapon.can_change:
		return
	
	var previous_weapon = active_weapon
	if previous_weapon == available_weapons[0]:
		active_weapon = available_weapons[1]
	else:
		active_weapon = available_weapons[0]
		
	active_weapon.visible = true
	active_weapon.active = true
	
	previous_weapon.visible = false
	previous_weapon.active = false
