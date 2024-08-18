#Explosion
extends Node2D	
@onready var damage_dealer: DamageDealer = $DamageDealer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#save pushed objects so it only pushes them once in case the hit activates many times for separate targets
var pushed_objects: Array = []
var flag = false

func _ready() -> void:
	damage_dealer.body_hit.connect(_on_hit)
	damage_dealer.target_hit.connect(_on_hit)

func _on_hit(_b :Node2D):
	#once
	if flag : return
	flag = true
	
	animation_player.play("explosion")
	animation_player.animation_finished.connect(func(_s): queue_free())
	
	await  get_tree().physics_frame
	var bodies = damage_dealer.get_overlapping_bodies()
	#push physics bodies that are not damaged too then die
	for b in damage_dealer.get_overlapping_bodies():
		if (b is RigidBody2D
		and not pushed_objects.has(b)
		and not (b is Minion or b is Player)):
			push(b)

func push(b : RigidBody2D):
	var dir := self.position.direction_to(b.position) 
	var distance_mod := 1 - 1/self.position.distance_squared_to(b.position)
	b.apply_central_impulse( damage_dealer.impact * dir * distance_mod )
	pushed_objects.append(b)
	print(pushed_objects)

	
