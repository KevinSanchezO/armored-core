extends CharacterBody3D
class_name Trail

@onready var face_direction := $FaceDirection as FaceDirection
@onready var velocity_3d := $Velocity3d as Velocity3D
@onready var particles := $GPUParticles3D as GPUParticles3D

var objective : Projectile
var emit_particles := true

func _ready() -> void:
	particles.one_shot = true
	particles.emitting = true
	particles.finished.connect(queue_free)

func _physics_process(_delta) -> void:
	if objective == null: return

	var move_direction := _get_direction()
	velocity_3d.accelerate(move_direction)
	velocity_3d.move(self, false)

func _get_direction() -> Vector3:
	return -face_direction.global_transform.basis.z
