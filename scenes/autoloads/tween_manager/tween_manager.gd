extends Node

func create_new_tween(object, modify_attribute:String, desired_goal_value, duration:float, from_value) -> void:
	var new_tween := get_tree().create_tween() as Tween
	
	new_tween.tween_property(object, modify_attribute,
	desired_goal_value, duration).from(from_value)
