class_name Player
extends RigidBody2D

signal died
signal hp_changed(hp : int)

@export var max_hp: int = 10
@onready var hp :int = max_hp:
	set(v):
		hp = v
		hp_changed.emit(v)


@export var speed :float = 2000
@export var spell_cooldown = 0.5

var damage_group :int = Globals.DamageGroups.PLAYER

var target_direction : Vector2
var can_shoot := true


const PROJECTILE = preload("res://scenes/projectile.tscn")

@onready var hand_rotation: Node2D = $"Sprite2D/Hand Rotation"
@onready var hand: Marker2D = $"Sprite2D/Hand Rotation/Hand"
@onready var spell_cooldown_timer: Timer = $SpellCooldown


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player = self


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
