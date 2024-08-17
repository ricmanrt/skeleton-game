class_name DamageInfo
extends RefCounted

var damage : int
var impulse : Vector2

func _init(damage: int, impulse : Vector2) -> void:
	self.damage = damage
	self.impulse = impulse
