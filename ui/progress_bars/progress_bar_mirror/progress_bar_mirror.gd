@tool
extends HBoxContainer
class_name ProgressBarMirror

@export var show_previous_state := false

@onready var progress_bar_left := $ProgressBarTemplate as ProgressBarTemplate
@onready var progress_bar_right := $ProgressBarTemplate2 as ProgressBarTemplate

func _ready() -> void:
	progress_bar_left.use_previous_state = show_previous_state
	progress_bar_right.use_previous_state = show_previous_state


func init_progress_bar_mirror(new_value:float) -> void:
	progress_bar_left.init_value(new_value)
	progress_bar_right.init_value(new_value)


func update_value_bar_mirror(new_value:float) -> void:
	progress_bar_left.value_progress_bar = int(new_value)
	progress_bar_right.value_progress_bar = int(new_value)


func update_color_bar_mirror(color:Color) -> void:
	progress_bar_left.update_color(color)
	progress_bar_right.update_color(color)
