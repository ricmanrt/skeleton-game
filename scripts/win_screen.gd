extends Control

var text = """
The townsfolk have suffered for their arrogance and noise making. 

your destruction is worth, hmm... %d points. Great job.
"""
@onready var win_label: Label = %WinLabel

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	%ExitButton.pressed.connect(_on_exit_btn)

func _on_visibility_changed() -> void:
	if (visible):
		win_label.text = text % Globals.score
		win_label.visible_ratio = 0
		create_tween().tween_property(win_label,"visible_ratio",1.0,4.0)

func _on_exit_btn():
	get_tree().quit()
