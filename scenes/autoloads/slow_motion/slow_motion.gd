extends Node

signal slow_motion_started()
signal slow_motion_ended()

var current_engine_scale := Engine.time_scale as float
var slow_motion_active : bool

