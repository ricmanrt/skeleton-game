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

@onready var timer: Timer = $Timer

var valid_targets: Array[DamageTaker] = []
var can_hit = true

func _ready() -> void:
	timer.wait_time = hit_delay
	timer.timeout.connect(_on_attack_cooldown)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)

func damage_all_targets() -> void:
	if can_hit:
		valid_targets.map(deal_damage) 
		can_hit = false
		timer.start()

func deal_damage(a : DamageTaker) -> void:
	if damage_groups & a.damage_group:
		var impulse := global_position.direction_to(a.owner.global_position) * impact
		a.damage_taken.emit(DamageInfo.new( damage, impulse))
		target_hit.emit(a)

func _on_area_entered(area: Area2D) -> void:
	if (area is DamageTaker 
		and damage_groups & area.damage_group
		and  not valid_targets.has(area)):
		
		valid_targets.append(area)
		await get_tree().process_frame
		damage_all_targets()

func _on_area_exited(area: Area2D) -> void:
	if (area is DamageTaker):
		valid_targets.erase(area)

func _on_body_entered(body: Node2D) -> void:
	body_hit.emit(body)

func _on_attack_cooldown()-> void:
	can_hit = true
	damage_all_targets()
