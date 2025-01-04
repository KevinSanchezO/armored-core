extends Node
class_name AirMovement

signal upward_force_applied()

const GRAVITY := 9.8
const FALL_GRAVITY := 19.6

@export var jump_velocity := 10.0
@export var air_speed := 6.0

@onready var current_jump_velocity = jump_velocity
@onready var current_air_speed = air_speed
@onready var current_gravity := GRAVITY
@onready var current_fall_gravity := FALL_GRAVITY

func apply_gravity(entity:Entity) -> void:
	if entity.velocity.y >= 0:
		entity.velocity.y -= current_gravity * get_process_delta_time()
	else:
		entity.velocity.y -= current_fall_gravity * get_process_delta_time()

func apply_upward_force(entity:Entity) -> void:
	upward_force_applied.emit()
	entity.velocity.y = current_jump_velocity
