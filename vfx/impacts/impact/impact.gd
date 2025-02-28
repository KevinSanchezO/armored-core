extends GPUParticles3D
class_name Impact

func _ready() -> void:
	self.emitting = true
	self.finished.connect(queue_free)

func rotate_impact(desired_direction : Vector3) -> void:
	var normalized_direction := desired_direction.normalized()
	
	if self.process_material is ParticleProcessMaterial:
		var material := self.process_material as ParticleProcessMaterial
		material.direction = normalized_direction
