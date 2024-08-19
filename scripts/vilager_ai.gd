# Basic AI
extends Node

@onready var group: MinionGroup = $".."

var target : Node2D

func _ready() -> void:
	await group.ready
	group.moving = false
	group.near_area.body_entered.connect(_on_body_entered)
	group.near_area.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if target == null:
		group.moving = false
	else: 
		group.target.position = group.average_position.position + target.position.direction_to(group.average_position.position) * 10
		group.moving = true

func _on_body_entered(body: Node2D):
	if body is Player:
		target = body
		Globals.debug_message = "run away form player"
	elif target == null and body is Minion:
		Globals.debug_message = "Found "+ body.name
		var m = body as Minion
		if m.damage_group == Globals.DamageGroups.SKELETONS:
			target = body
			Globals.debug_message = "got target bones"

func _on_body_exited(body: Node2D):
		target = null
		group.moving = false
		Globals.debug_message = "no target bones"
