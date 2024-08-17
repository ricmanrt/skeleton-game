class_name DamageDealer
extends Area2D


## hit a valid target
signal target_hit(target:Node2D)
## hit a solid thing
signal body_hit(body:Node2D)

@export var damage : int = 1
@export var impact : float = 1
@export var hit_delay: float = 0.5
@export_flags("Player:2", "Skeletons:4", "Enemies:8") var damage_groups:int;


var can_hit = true

@onready var timer: Timer = $Timer



func _ready() -> void:
	self.set_collision_mask_value(1, false)
	timer.wait_time = hit_delay
	timer.timeout.connect(_on_attack_cooldown)


func _on_target_hit(target: Node2D) -> void:
	can_hit = false

func _on_body_entered(body: Node2D) -> void:
	body_hit.emit(body)

func _on_attack_cooldown()-> void:
	can_hit = true
