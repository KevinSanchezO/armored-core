extends Weapon
class_name MeleeWeapon

signal melee_used()

@onready var hurtbox := $Hurtbox as Hurtbox

func _ready() -> void:
	super()
	
	disable_hurtbox()
	hurtbox.damage = damage
	self.melee_used.connect(fire_rate.start)
	self.melee_used.connect(fire_audio.play_audio)

func trigger_hurtbox() -> void:
	hurtbox.enable()

func disable_hurtbox() -> void:
	hurtbox.disable()

func start_attack() -> void:
	animation.play("fire")

func finish_attack() -> void:
	animation.play("reload")
