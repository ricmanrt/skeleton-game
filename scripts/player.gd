class_name Player
extends RigidBody2D

signal died
signal hp_changed(hp : int)

@export var max_hp: int = 20
@onready var hp :int = max_hp:
	set(v):
		hp = v
		hp_changed.emit(v)


@export var speed :float = 2000
@export var spell_cooldown = 0.5

var damage_group :int = Globals.DamageGroups.PLAYER
var dead = false
var target_direction : Vector2
var can_shoot := true

const PROJECTILE = preload("res://scenes/projectile.tscn")

@onready var hand_rotation: Node2D = $"Sprite2D/Hand Rotation"
@onready var hand: Marker2D = $"Sprite2D/Hand Rotation/Hand"
@onready var spell_cooldown_timer: Timer = $SpellCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player = self
	$DamageTaker.damage_group = damage_group

func _physics_process(delta: float) -> void:
	target_direction = Input.get_vector("move_left","move_right", "move_up", "move_down")
	apply_central_force(target_direction * speed * delta* 20)

func _process(delta: float) -> void:
	hand_rotation.look_at(get_global_mouse_position())
	
	if (can_shoot and Input.is_action_pressed("shoot")):
		can_shoot = false
		spell_cooldown_timer.start(spell_cooldown)
		var p := PROJECTILE.instantiate()
		p.position = hand.global_position
		p.projectile_emitter = self
		p.direction = hand.global_position.direction_to(get_global_mouse_position())
		get_parent().add_child(p)

func _on_spell_cooldown_timeout() -> void:
	can_shoot = true

func _on__damage_taken(damage_info: DamageInfo) -> void:
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

func die() -> void:
	dead = true
	died.emit()
	self.set_process(false)
