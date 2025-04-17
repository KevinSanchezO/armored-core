extends CharacterBody3D
class_name Entity 

@onready var velocity_3d := $Velocity3d as Velocity3D
@onready var armor_points := $ArmorPoints as Health
@onready var hitbox := $Hitbox as Hitbox

var loss_of_control_effects := []
var wish_dir := Vector3.ZERO


func add_loss_of_control_effect(effect_to_add: Variant, remove_signal: Signal) -> void:
	loss_of_control_effects.append(effect_to_add)
	remove_signal.connect(remove_loss_of_control_effect.bind(effect_to_add))


func remove_loss_of_control_effect(effect_to_remove: Variant) -> void:
	loss_of_control_effects.erase(effect_to_remove)
