extends CanvasLayer

const SAFE_BOOST_COOLOR := Color(0.255, 0.392, 0.82) as Color
const DANGER_BOOST_COLOR := Color(1, 0.133, 0.173) as Color

@export var entity : Entity

@onready var energy_gauge := $"../EnergyGauge" as EnergyGauge
@onready var label_pos := $MarginContainer/Control/VBoxContainer/LabelPosition as Label
@onready var label_boost := $MarginContainer/Control/VBoxContainer/LabelBoost as Label

func _ready() -> void:
	energy_gauge.cooldown_started.connect(_on_cooldown_started)
	energy_gauge.cooldown_ended.connect(_on_cooldown_ended)

func _process(_delta) -> void:
	_update_label_pos()
	_update_label_boost()

func _update_label_pos() -> void:
	var velocity_x := "velocity.x = " + str(entity.velocity.x) + "\n"
	var velocity_y := "velocity.y = " + str(entity.velocity.y) + "\n"
	var velocity_z := "velocity.z = " + str(entity.velocity.z) + "\n"
	label_pos.text = velocity_x + velocity_y + velocity_z

func _update_label_boost() -> void:
	label_boost.text = str(energy_gauge.energy_gauge)

func _on_cooldown_started() -> void:
	label_boost.modulate = DANGER_BOOST_COLOR

func _on_cooldown_ended() -> void:
	label_boost.modulate = SAFE_BOOST_COOLOR
