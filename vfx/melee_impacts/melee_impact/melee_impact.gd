extends GPUParticles3D
class_name MeleeImpact


@export var is_one_shot := true:
	set(value):
		self.one_shot = value


func particle_is_emitting(value:bool) -> void:
	self.emitting = value
