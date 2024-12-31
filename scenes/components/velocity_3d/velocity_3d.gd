extends Node
class_name Velocity3D

@export var max_speed := 8.0
@export var acceleration := 50.0

var velocity := Vector3.ZERO

@onready var current_speed = max_speed

func accelerate(direction: Vector3, speed := current_speed as float) -> void:
	var desired_velocity := direction * speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func move(body:Entity) -> void:
	body.velocity.x = velocity.x
	body.velocity.z = velocity.z
	body.move_and_slide()
