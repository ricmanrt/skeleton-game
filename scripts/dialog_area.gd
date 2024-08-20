#Dialog Area
extends Area2D

@export var one_shot := true
@export var active := true
@export_multiline  var text: String 
#@export var duration := 3

var was_triggered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered);

func _body_entered(b : Node2D) -> void:
	if (not active) or (one_shot and was_triggered):
		return
	assert(b is Player)
	var player := b as Player
	was_triggered = true
	player.talk(text)
