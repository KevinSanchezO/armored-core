extends Area3D
class_name WallJumpHandler

@onready var sleep_timer := $SleepTimer as Timer

@export var wall_jump_sleep_value := 0.3 :
	set(value):
		sleep_timer.wait_time = value

var colliding_with_surface := false


func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_enter_slow_motion_jump)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion_jump)
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body) -> void:
	if body.get_collision_layer() == 1:
		colliding_with_surface = true
		print("wall jump available")


func _on_body_exited(body) -> void:
	if body.get_collision_layer() == 1:
		colliding_with_surface = false
		print("wall NOT jump available")


func _enter_slow_motion_jump() -> void:
	TweenManager.create_new_tween(sleep_timer, "wait_time", \
	wall_jump_sleep_value / 2, 0.5, sleep_timer.wait_time)


func _exit_slow_motion_jump() -> void:
	TweenManager.create_new_tween(sleep_timer, "wait_time", \
	wall_jump_sleep_value, 0.5, sleep_timer.wait_time)
