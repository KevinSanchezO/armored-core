extends Node3D
class_name Weapon

@export var weapon_name : String
@export var fire_rate_value := 0.1
@export var buffed_by_slowmotion := false
@export_range(0.0, 1.0, 0.05) var trauma : float
@export var damage := 0.0
@export var price := 0.0

@onready var fire_rate := $Firerate as Timer
@onready var animation := $AnimationPlayer as AnimationPlayer

@onready var fire_audio := $Audio/FireAudio as Audio3D
@onready var reload_audio := $Audio/ReloadAudio as Audio3D
@onready var ready_audio := $Audio/ReadyAudio as Audio3D
@onready var empty_audio := $Audio/EmptyAudio as Audio3D

var active := false
var can_change := true
var spent := 0.0
var firing := false
var entity : Player

func _ready() -> void:
	fire_rate.wait_time = fire_rate_value
	
	if buffed_by_slowmotion:
		SlowMotion.slow_motion_started.connect(_enter_slow_motion)
		SlowMotion.slow_motion_ended.connect(_exit_slow_motion)

func _start_weapon_activation() -> void:
	pass

func activate_weapon() -> void:
	can_change = true
	active = true

func _enter_slow_motion() -> void:
	TweenManager.create_new_tween(fire_rate, "wait_time", \
	fire_rate_value / 2, 0.5, fire_rate.wait_time)

func _exit_slow_motion() -> void:
	TweenManager.create_new_tween(fire_rate, "wait_time", \
	fire_rate_value, 0.5, fire_rate.wait_time)
