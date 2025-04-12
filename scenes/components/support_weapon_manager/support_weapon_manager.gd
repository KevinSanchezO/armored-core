extends Node3D
class_name SupportWeaponManager

@export var entity : Entity
@export var raycast_range_weapons : RaycastRangeWeapon

var active_weapon : Weapon

func _ready() -> void:
	_load_support_weapon()


func _load_support_weapon() -> void:
	var weapon_to_load := SupportWeaponLoad.available_weapon as String
	var weapon_scene := load(weapon_to_load) as PackedScene
	var weapon_instance := weapon_scene.instantiate() as Weapon
	
	self.add_child(weapon_instance)
	weapon_instance.global_position = self.global_position
	
	weapon_instance.entity = entity
	weapon_instance.raycast_range_weapon = raycast_range_weapons
	weapon_instance.visible = false
	print(weapon_instance)
	
	active_weapon = weapon_instance
	active_weapon.activate_weapon()
	active_weapon.visible = true
