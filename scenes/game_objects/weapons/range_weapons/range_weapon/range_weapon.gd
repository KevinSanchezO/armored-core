extends Weapon
class_name RangeWeapon

signal weapon_fired()
signal weapon_reloaded()

@export var projectiles_per_shoot : int
@export_range(0.0, 0.3, 0.001) var spread : float
@export var max_ammo : int
@export var max_chamber : int
@export var projectile : PackedScene
@export_range(0, 160, 1) var hit_marker_size : int 

var current_max_ammo : int
var current_chamber : int
var raycast_range_weapon : RaycastRangeWeapon

@onready var projectile_spawner := $ProjectileSpawner as Node3D
@onready var shell_spawner := $ShellSpawner as Node3D


func _ready() -> void:
	super()
	current_max_ammo = max_ammo
	current_chamber = max_chamber
	
	self.weapon_fired.connect(fire_rate.start)
	self.weapon_fired.connect(fire_audio.play_audio)


func start_reload() -> void:
	if current_chamber == max_chamber:
		return
	
	active = false
	can_change = false
	animation.play("reload")


func _reload() -> void:
	var bullets_needed := max_chamber - current_chamber
	
	if current_max_ammo >= bullets_needed:
		current_max_ammo -= bullets_needed
		current_chamber = max_chamber
	else:
		current_chamber += current_max_ammo
		current_max_ammo = 0
	weapon_reloaded.emit()
	can_change = true
	active = true

func generate_projectile():
	var entity_layer := get_tree().get_first_node_in_group("projectile_layer") as Node3D
	if entity_layer == null:
		push_error("No entity layer found.")
	
	if projectile == null:
		push_error("No projectile found.")
	
	if current_chamber == 0:
		empty_audio.play_audio()
		return
	
	firing = true
	for p in projectiles_per_shoot:
		var projectile_instance = projectile.instantiate() as Projectile
		
		entity_layer.add_child(projectile_instance)
		
		raycast_range_weapon.spread = spread
		var random_direction := raycast_range_weapon.cast_ray()
		
		projectile_instance.hurtbox.damage = damage
		
		projectile_instance.global_position = projectile_spawner.global_position
		
		projectile_instance.look_at(projectile_instance.global_position + random_direction, Vector3.UP)
	
		projectile_instance.generate_trail(random_direction)
	
	firing = false
	current_chamber -= 1
	weapon_fired.emit()
	animation.play("fire")
	Camera.apply_screen_shake(trauma)
