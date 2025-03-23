extends Node
class_name Velocity3D

signal upward_force_applied()

const GRAVITY := 9.8
const FALL_GRAVITY := 19.6

@export var max_speed := 8.0
@export var acceleration := 30.0
@export var jump_velocity := 9.0
@export var air_speed := 6.0

var velocity := Vector3.ZERO

@onready var current_speed = max_speed
@onready var current_jump_velocity = jump_velocity
@onready var current_air_speed = air_speed
@onready var current_gravity := GRAVITY
@onready var current_fall_gravity := FALL_GRAVITY

func accelerate(direction: Vector3, speed := current_speed as float) -> void:
	var desired_velocity := direction * speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func apply_gravity(entity:Entity) -> void:
	if entity.velocity.y >= 0:
		entity.velocity.y -= current_gravity * get_process_delta_time()
	else:
		entity.velocity.y -= current_fall_gravity * get_process_delta_time()

func apply_upward_force(entity:Entity) -> void:
	upward_force_applied.emit()
	entity.velocity.y = current_jump_velocity

func move(body:CharacterBody3D, ignore_y := true) -> void:
	if not ignore_y:
		body.velocity.y = velocity.y
	body.velocity.x = velocity.x
	body.velocity.z = velocity.z
	body.move_and_slide()
