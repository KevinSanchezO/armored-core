extends MeleeWeapon
class_name EnergySword

@onready var energy_impact := $Model/EnergyImpact as MeleeImpact


func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_just_pressed("left_weapon") and fire_rate.is_stopped():
		animation.play("attack")
		fire_rate.start()


func _modify_energy_impact_emission(value:bool) -> void:
	energy_impact.particle_is_emitting(value)
