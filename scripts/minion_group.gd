class_name MinionGroup
extends Node2D

signal unit_count_changed
signal unit_died(unit : Minion)
signal unit_summoned

@export var unit_prefab : PackedScene
@export var unit_speed := 400
@export var max_units: int = 128

@export_category("audio")
@export var summon_sound: AudioStream
@export var hit_sound: AudioStream
@export var death_sound: AudioStream

var moving = true

@onready var units: Node2D = $Units
@onready var target: Marker2D = $Target
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var average_position: Marker2D = $AveragePosition
@onready var near_area: Area2D = $AveragePosition/Area2D
@onready var arrow: Node2D = $AveragePosition/Arrow

@onready var unit_count: int = units.get_child_count():
	set = set_unit_count

func set_unit_count(v:int) ->void:
	unit_count = v
	unit_count_changed.emit(v)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var initial_offset := position
	self.position = Vector2.ZERO #move back to 0 to avoid position nonsense
	
	unit_count = units.get_child_count()
	for u in units.get_children():
		assert (u is Minion )
		u.position += initial_offset
		average_position.position = u.position
		connect_unit(u as Minion)

func connect_unit(unit: Minion):
	unit.died.connect(_on_unit_death.bind(unit))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_units(delta)

func _on_unit_death(unit) -> void:
	unit_died.emit(unit)
	
	audio_stream_player.pitch_scale = randf_range(0.7, 0.9)
	audio_stream_player.stream = death_sound
	audio_stream_player.play()

func summon_unit(pos: Vector2)-> void:
	if unit_count >= max_units:
		#TODO: find the weakest unit and kill it
		units.get_child(0).die()
	
	var s = unit_prefab.instantiate()
	s.position = pos
	
	units.add_child.call_deferred(s)
	connect_unit.call_deferred(s)
	unit_summoned.emit.call_deferred()
	
	audio_stream_player.pitch_scale = randf_range(0.7, 0.9)
	audio_stream_player.stream = summon_sound
	audio_stream_player.play()

func move_units(delta: float) -> void:
	set_unit_count(units.get_child_count())
	if (not moving or unit_count == 0) : 
		arrow.hide()
		return
	
	var avg_pos := Vector2.ZERO
	for s in units.get_children():
		assert(s is Minion)
		var unit := s as Minion
		var direction := unit.position.direction_to(target.position)
		unit.apply_central_force(direction * unit_speed * unit.speed_variation * delta * 60 )
		avg_pos+= unit.position
	avg_pos = avg_pos / unit_count
	
	average_position.position = avg_pos
	
	average_position.look_at(target.position)
	arrow.length = min( 128,  (avg_pos - target.position).length() - 32 )
	
	arrow.visible = arrow.length > 16 #hide arrow if it isnt very long
	
