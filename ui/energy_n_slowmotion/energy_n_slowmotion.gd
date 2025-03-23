extends VBoxContainer
class_name EnergyNSlowmotion

@onready var slow_motion_count := $SlowmotionCount as Label
@onready var slow_motion_bar := $HBoxContainer/Slowmotion as ProgressBarMirror
@onready var energy_bar := $HBoxContainer2/Energy as ProgressBarMirror

var max_slow_motion_count := 2
var current_slow_motion_count := 0

func set_ready(new_energy_gauge:float, new_slowmotion_gauge:float, max_count:int) -> void:
	energy_bar.init_progress_bar_mirror(new_energy_gauge)
	slow_motion_bar.init_progress_bar_mirror(new_slowmotion_gauge)
	
	max_slow_motion_count = max_count


func update_bars_mirror(new_energy_gauge:float, new_slowmotion_gauge:float) -> void:
	energy_bar.update_value_bar_mirror(new_energy_gauge)
	slow_motion_bar.update_value_bar_mirror(new_slowmotion_gauge)


func update_energy_bar_color(color:Color) -> void:
	energy_bar.update_color_bar_mirror(color)


func update_slowmotion_bar_color(color:Color) -> void:
	slow_motion_bar.update_color_bar_mirror(color)


func set_current_slow_motion_count() -> void:
	if !current_slow_motion_count + 1 > max_slow_motion_count:
		current_slow_motion_count += 1


func update_slow_motion_label() -> void:
	slow_motion_count.text = str(current_slow_motion_count) + "|" + str(max_slow_motion_count)
