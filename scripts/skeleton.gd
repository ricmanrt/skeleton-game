class_name Skeleton
extends RigidBody2D

@export var max_hp: int = 10
@onready var hp :int = max_hp

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


signal died

func take_damage(damage : Dictionary) -> void:
	assert(false)
	var dmg = damage.damage
	var impulse = damage.impulse
	apply_central_impulse(impulse)
	
	hp -= dmg
	if(hp <= 0):
		die()
	pass

func die() ->void:
	animation_player.play("death")
	await animation_player.animation_finished
	
	died.emit()
	queue_free()


func _on_damage_taken(damage_info: DamageInfo) -> void:
	hp -= damage_info.damage
	
	apply_central_impulse(damage_info.impulse)
	if(hp <= 0):
		die()
	else:
		animation_player.play("hit")
		sprite_2d.rotation_degrees = randf_range(-15,15);
		await animation_player.animation_finished
		sprite_2d.rotation = 0;
		animation_player.play("idle")
