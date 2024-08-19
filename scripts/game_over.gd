#Game Over
class_name GameOver
extends Control

#const MAIN = preload("res://scenes/main.tscn")

@onready var score_label: Label = %ScoreLabel
@onready var restart_btn: Button = %RestartBtn
@onready var exit_btn: Button = %ExitBtn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_btn.pressed.connect(_on_restart)
	exit_btn.pressed.connect(_on_exit)
	Globals.score_changed.connect(func(i: int): score_label.text = "score: %06d" % i)

func _on_exit()->void:
	get_tree().quit()

func _on_restart()->void:
	Globals.player = null
	Globals.score = 0
	get_tree().reload_current_scene()
