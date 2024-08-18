class_name DamageTaker
extends Area2D

signal damage_taken(damage_info: DamageInfo)

#I'll remove this soon and give this responsibility to owner
@export_enum("Player:2", "Skeletons:4", "Enemies:8") var damage_group: int;

func _ready() ->void:
	damage_group = owner.damage_group 
