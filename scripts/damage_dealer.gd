class_name DamageDealer
extends Area2D

@export var damage : int = 1
@export var impact : float = 1
@export_flags("Player:2", "Skeletons:4", "Enemies:8") var damage_groups:int;

## hit a valid target
signal target_hit(target:Node2D)
## hit a solid thing
signal body_hit(body:Node2D)

func _ready() -> void:
	self.set_collision_mask_value(1, false)


func _on_body_entered(body: Node2D) -> void:
	body_hit.emit(body)
