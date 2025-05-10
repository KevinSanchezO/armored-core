extends MeshInstance3D
class_name WallJumpVisualizer


@export var rotation_mult := 1.0

@onready var current_rotation_mult := rotation_mult

func _ready() -> void:
	SlowMotion.slow_motion_started.connect(_enter_slow_motion)
	SlowMotion.slow_motion_ended.connect(_exit_slow_motion)
	

func rotate_visualizer(delta: float) -> void:
	self.rotation.y += current_rotation_mult * delta


func modify_color(color:Color) -> void:
	self.mesh.material.albedo_color = color


func _enter_slow_motion() -> void:
	TweenManager.create_new_tween(self, "current_rotation_mult", \
	rotation_mult * 2, 0.5, current_rotation_mult)


func _exit_slow_motion() -> void:
	TweenManager.create_new_tween(self, "current_rotation_mult", \
	rotation_mult, 0.5, current_rotation_mult)
