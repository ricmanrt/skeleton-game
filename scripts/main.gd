extends Node2D

@export var win_condition : int = 30
@export_category("skeletons")
@export var skeleton_speed :float = 1000
@export var skele_speed_variance : float = 0.2
@export var max_skeletons: int = 128

@export_category("camera")
@export var min_zoom  :float = 0.5
@export var max_zoom :float = 1.5
@export var zoom_speed :float = 5.0

var camera_zoom := 1.0
var paused = false
var game_over = false
const PICKUP = preload("res://scenes/pickup.tscn")
const GAME_OVER_SONG = preload("res://music/Game Over.ogg")
const GAME_OVER_SFX = preload("res://sounds/game_over.ogg")
const PAUSED_SFX = preload("res://sounds/paused.ogg")

@onready var player: Player = %Player
@onready var cursor: Sprite2D = $Cursor
@onready var camera: Camera2D = $Player/Camera2D
@onready var map_objects: Node2D = $"Map objects"
@onready var skeleton_group: MinionGroup = $Groups/SkeletonGroup
@onready var win_area: Area2D = $"Win Area"
@onready var groups: Node2D = $Groups
@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer
@onready var sfx: AudioStreamPlayer = $SFX


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	GlobalEvents.skeleton_pickup.connect(_on_pickup)
	GlobalEvents.item_dropped.connect(_on_item_drop)
	
	player.died.connect(_on_player_died)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel") ):
		pause_toggle()
	if (event.is_action_pressed("ui_accept") ):
		pass
		#summon_skeleton(cursor.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skeleton_group.target.position = cursor.position
		
	camera_zoom = remap(skeleton_group.unit_count, 0, skeleton_group.max_units, max_zoom, min_zoom)
	camera.zoom = lerp(camera.zoom, Vector2.ONE * camera_zoom, delta*zoom_speed)
	
	%SkeletonCount.text = "skeleton count: %d/%d " % [skeleton_group.unit_count, win_condition]
	%DebugLabel.text = Globals.debug_message
	
	if win_area.get_overlapping_bodies().has(player):
		if skeleton_group.unit_count >= win_condition:
			_on_victory()

func _on_player_died():
	%GameOver.show()
	game_over = true
	pause()
	
	music_stream_player.stream = GAME_OVER_SONG
	music_stream_player.play()
	
	sfx.stream = GAME_OVER_SFX
	sfx.play()

func _on_victory():
	%WinScreen.show()
	game_over = true
	pause()

func pause_toggle() -> void:
	if game_over: return
	if paused:
		paused = false
		music_stream_player.stream_paused = false
		%PauseScreen.hide()
		unpause()
	else: 
		paused = true
		music_stream_player.stream_paused = true
		
		sfx.stream = PAUSED_SFX
		sfx.play()
		
		%PauseScreen.show()
		pause()

func pause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_node(self)
	pause_node(player)
	for g in groups.get_children():
		pause_node(g)

func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	unpause_node(self)
	unpause_node(player)
	for g in groups.get_children():
		unpause_node(g)

func pause_node(node : Node) -> void:
	node.set_process(false)
	node.set_physics_process(false)

func unpause_node(node : Node) -> void:
	node.set_process(true)
	node.set_physics_process(true)

func _on_item_drop(pos: Vector2) ->void: 
	var d := PICKUP.instantiate()
	d.position = pos
	map_objects.add_child(d)

func _on_pickup(pos : Vector2) -> void:
	summon_skeleton(pos)

func summon_skeleton(pos: Vector2)-> void:
	skeleton_group.summon_unit(pos)
