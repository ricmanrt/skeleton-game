#Score Label
extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.score_changed.connect(
		func(score):
			text = "Score: %06d" % score
	)
