@tool
extends ProgressBar
class_name ProgressBarTemplate

@export var use_previous_state := true

var value_progress_bar := 0 : set = _set_value_progress_bar

@onready var previous_state_bar := $PreviousState as ProgressBar
@onready var timer_previous_state := $Timer as Timer


func _ready() -> void:
	timer_previous_state.timeout.connect(_timer_timeout)
	
	previous_state_bar.fill_mode = self.fill_mode
	
	previous_state_bar.visible = use_previous_state


func init_value(new_value:float) -> void:
	value_progress_bar = int(new_value)
	
	max_value = int(new_value)
	value = int(new_value)
	
	previous_state_bar.max_value = int(new_value)
	previous_state_bar.value = int(new_value)


func _set_value_progress_bar(new_value:float) -> void:
	var previous_value := value_progress_bar
	value_progress_bar = min(max_value, new_value)
	value = int(value_progress_bar)
	
	if value_progress_bar < previous_value:
		timer_previous_state.start()
	else:
		previous_state_bar.value = value_progress_bar


func update_color(new_color:Color) -> void:
	var stylebox_flat = get_theme_stylebox("fill", "ProgressBar")
	stylebox_flat.bg_color = new_color
	add_theme_stylebox_override("fill", stylebox_flat)


func _timer_timeout() -> void:
	previous_state_bar.value = value_progress_bar
