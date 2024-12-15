extends CharacterBody3D
class_name Entity 

@onready var air_movement := $AirMovement as AirMovement
@onready var ground_movement := $GroundMovement as GroundMovement

var wish_dir := Vector3.ZERO
