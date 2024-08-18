# PROJECTILE
extends Node2D

@export var on_hit_summon : PackedScene
@export var velocity := 400

@onready var damage_dealer: DamageDealer = $DamageDealer

var direction : Vector2
var projectile_emitter : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_dealer.body_hit.connect(_on_damage_dealer_hit)
	damage_dealer.target_hit.connect(_on_damage_dealer_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * velocity * delta 

func summon() -> void:
	if (on_hit_summon != null):
		var n = on_hit_summon.instantiate()
		n.position = position
		get_parent().add_child.call_deferred(n)

func _on_lifetime_timeout() -> void:
	explode()

func _on_damage_dealer_hit(body: Node2D) -> void:
	if body == projectile_emitter: 
		return
	else:
		explode()

func explode()->void:
	queue_free()
	summon()
