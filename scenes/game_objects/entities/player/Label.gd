extends Label


@export var entity : Entity

func _process(_delta) -> void:
	var velocity_x = "velocity.x = " + str(entity.velocity.x) + "\n"
	var velocity_y = "velocity.y = " + str(entity.velocity.y) + "\n"
	var velocity_z = "velocity.z = " + str(entity.velocity.z) + "\n"
	var boost = "energy = " + str($"../EnergyGauge".energy_gauge) 
	self.text = velocity_x + velocity_y + velocity_z + boost
