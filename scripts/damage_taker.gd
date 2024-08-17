class_name DamageTaker
extends Area2D

@export_enum("Player:2", "Skeletons:4", "Enemies:8") var damage_group: int;

signal damage_taken(damage_info: DamageInfo)

func _on_area_entered(area: Area2D) -> void:
	assert(area is DamageDealer)
	var a := area as DamageDealer
	
	if a.damage_groups & damage_group:
		var impulse := a.position.direction_to(position) * a.impact		
		damage_taken.emit(DamageInfo.new( a.damage, impulse))
		a.target_hit.emit(owner)
