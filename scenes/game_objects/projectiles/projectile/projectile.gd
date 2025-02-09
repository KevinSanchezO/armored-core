extends CharacterBody3D
class_name Projectile

@export var impact_scene : PackedScene
@export var debris : PackedScene
@export var trail : PackedScene
@export var rotate_impact := false
@export var speed_value_min := 0.0
@export var speed_value_max := 0.0
@export var max_impacts := 1
@export var queue_free_timer_value := 1.5

@onready var impact_point := $ImpactPoint as Node3D
@onready var velocity_3d := $Velocity3d as Velocity3D
@onready var hurtbox := $Hurtbox as Hurtbox
@onready var face_direction := $FaceDirection as FaceDirection
@onready var queue_free_timer := $QueueFreeTimer as Timer

var impacts := 0

func _ready() -> void:
	velocity_3d.max_speed = randf_range(speed_value_min, speed_value_max)
	velocity_3d.current_speed = velocity_3d.max_speed
	queue_free_timer.wait_time = queue_free_timer_value
	
	hurtbox.wall_impacted.connect(_update_impacts.bind(debris))
	hurtbox.damage_dealt.connect(_update_impacts.bind(impact_scene, max_impacts))
	queue_free_timer.timeout.connect(queue_free)

func _physics_process(_delta) -> void:
	var move_direction := _get_direction()
	velocity_3d.accelerate(move_direction)
	velocity_3d.move(self, false)

func _get_direction() -> Vector3:
	return -face_direction.global_transform.basis.z

func _update_impacts(impact:PackedScene, value := 1) -> void:
	impacts += value

	if impact_scene != null:
		_generate_impact(impact)
	
	if impacts == max_impacts:
		queue_free()

func _generate_impact(impact:PackedScene) -> void:
	if impact == null:
		return
