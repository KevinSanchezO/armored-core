extends Node3D
class_name JumpHandler

@export var jump_consumption := 50.0
@export var jump_cooldown_value := 0.4

@onready var jump_cooldown := $JumpCooldown as Timer

func _ready() -> void:
	jump_cooldown.wait_time = jump_cooldown_value

func _enter_slow_motion_jump() -> void:
	TweenManager.create_new_tween(jump_cooldown, "wait_time", \
	jump_cooldown_value / 2, 0.5, jump_cooldown.wait_time)

func _exit_slow_motion_jump() -> void:
	TweenManager.create_new_tween(jump_cooldown, "wait_time", \
	jump_cooldown_value, 0.5, jump_cooldown.wait_time)
