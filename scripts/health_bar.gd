extends Node2D
var max_hp = 10

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(owner.has_signal("hp_changed"))
	owner.connect("hp_changed", func (v:float): progress_bar.value = v )
	progress_bar.max_value = owner.max_hp
