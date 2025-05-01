extends RangeWeapon
class_name AssaultEnergyRifle

@onready var charging_animation := $Model/Charging as AnimatedSprite3D
@onready var charged_sprite := $Model/Charged as Sprite3D

@export var charge_limit := 50.0
@export var increase_value := 1.0

var charging := false
var current_charge := 0.0
var charge_complete : bool :
	get:
		return current_charge >= charge_limit


func _ready() -> void:
	super()
	charged_sprite.visible = false
	charging_animation.visible = false


func _physics_process(delta: float) -> void:
	charging_animation.rotation.z += 5 * delta
	charged_sprite.rotation.z += 5 * delta
	
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_pressed("right_weapon"):
		_handle_charging()
	
	if Input.is_action_just_released("right_weapon"):
		_handle_release()


func _handle_release() -> void:
	if charge_complete:
		generate_projectile()
	can_change = true
	charging = false
	current_charge = 0.0
	
	charged_sprite.visible = false
	charging_animation.visible = false


func _handle_charging() -> void:
	can_change = false
	charging = true
	
	current_charge += increase_value
	
	if charge_complete:
		charged_sprite.visible = true
		charging_animation.visible = false
	else:
		charged_sprite.visible = false
		charging_animation.visible = true
