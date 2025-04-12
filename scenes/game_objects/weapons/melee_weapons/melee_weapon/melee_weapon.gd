extends Weapon
class_name MeleeWeapon

signal melee_used()

@onready var hurtbox := $Hurtbox as Hurtbox

func _ready() -> void:
	super()
	
	self.melee_used.connect(fire_rate.start)
	self.melee_used.connect(fire_audio.play_audio)


func start_attack() -> void:
	pass
