extends Weapon
class_name MeleeWeapon

signal melee_used()

@onready var fire_audio := $Audio/FireAudio as Audio3D

@export var hurtbox_size:Vector3
@export_enum("BLUNT", "ENERGY", "EXPLOSION") var type_damage : String
@export var frame_freeze_value := 0.2

func _ready() -> void:
	super()
	
	self.melee_used.connect(fire_rate.start)
	self.melee_used.connect(fire_audio.play_audio)
	
	set_hurtbox_size.call_deferred()


func frame_freeze() -> void:
	FrameFreeze.frame_freeze(frame_freeze_value)


func set_hurtbox_size() -> void:
	entity.hurtbox_melee.set_parameters(damage, type_damage, hurtbox_size)
