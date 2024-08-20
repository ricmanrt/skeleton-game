# Cleric AI
extends Node

@onready var group: MinionGroup = $".."
@onready var spell_cooldown_timer: Timer = $"../SpellCooldown"
var can_shoot := true
@export var spell_cooldown = 0.5
const PROJECTILE = preload("res://scenes/holy_projectile.tscn")

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
		
		if (can_shoot and Input.is_action_pressed("shoot")):
			can_shoot = false
			spell_cooldown_timer.start(spell_cooldown)
			var p := PROJECTILE.instantiate()
			p.position = group.average_position.position
			p.projectile_emitter = self
			p.direction = group.average_position.position.direction_to(target.position)
			get_parent().add_child(p)
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
