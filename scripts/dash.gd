extends Node
class_name Dash

signal dash_started()
signal dash_finished()

var entity:Entity
var direction:Vector3
var duration:float
var speed: float
var progress := 0

static func create(dash_data: Dictionary) -> Dash:
	var new_dash := Dash.new()
	
	if not dash_data.has("speed"):
		push_error("MISSING PARAMETER ERROR: No speed found in dash_data Dictionary")
	new_dash.speed = dash_data.speed
	
	if not dash_data.has("duration"):
		push_error("MISSING PARAMETER ERROR: No duration found in dash_data Dictionary")
	new_dash.duration = dash_data.duration
	
	if not dash_data.has("entity"):
		push_error("MISSING PARAMETER ERROR: No entity found in dash_data Dictionary")
	new_dash.entity = dash_data.entity
	
	if not dash_data.has("direction"):
		push_error("MISSING PARAMETER ERROR: No direction found in dash_data Dictionary")
	new_dash.direction = dash_data.direction
	
	new_dash.start_dash()
	return new_dash


func dash_tween_method(tween_progress: float) -> void:
	entity.velocity_3d.accelerate(direction, speed)
	entity.velocity_3d.move(entity)
	progress = tween_progress


func set_direction(new_direction: Vector3) -> void:
	direction = new_direction


func start_dash() -> void:
	if entity == null:
		return
	dash_started.emit()
	
	var dash_tween := entity.create_tween()
	dash_tween.tween_method(dash_tween_method, 0.0, 1.0, duration)
	
	await dash_tween.finished
	end_dash()


func end_dash() -> void:
	dash_finished.emit()
	queue_free()
