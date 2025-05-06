extends MeleeWeapon
class_name Chainsaw

@onready var particle_effect_impact := $Model/Sprite3D/StunImpact as MeleeImpact


var chainsaw_active := false
var current_hurtbox_active := false


func _ready() -> void:
	super()
	
	fire_rate.timeout.connect(_firerate_audio_play)
	_particle_ready.call_deferred()


func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_pressed("left_weapon") and fire_rate.is_stopped():
		_fire_audio_play()
		if chainsaw_active and not(animation.current_animation == "start"):
			_active_attack_anim()
		else:
			_start_attack_anim()
		chainsaw_active = true
	
	if Input.is_action_just_released("left_weapon"):
		chainsaw_active = false
		fire_audio.stop()
		entity.hurtbox_melee.trigger_frame(5)
		if fire_rate.is_stopped():
			_reset_attack_anim()
		fire_rate.start()


func _particle_ready() -> void:
	entity.hurtbox_melee.damage_dealt.connect(_particle_impact_chainsaw)
	entity.hurtbox_melee.limit_impacted.connect(_particle_limit_chainsaw)

func _particle_impact_chainsaw() -> void:
	particle_effect_impact.particle_is_emitting(true)

func _particle_limit_chainsaw() -> void:
	pass


func _handle_hurtbox() -> void:
	current_hurtbox_active = not(current_hurtbox_active)
	entity.hurtbox_melee.disable() if current_hurtbox_active else entity.hurtbox_melee.enable() 


func _fire_audio_play() -> void:
	if chainsaw_active and not(fire_audio.playing):
		fire_audio.play_audio()

func _firerate_audio_play() -> void:
	ready_audio.play_audio()


func _start_attack_anim() -> void:
	animation.play("start")

func _active_attack_anim() -> void:
	animation.play("active")

func _reset_attack_anim() -> void:
	animation.play("reset")
