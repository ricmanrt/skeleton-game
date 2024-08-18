extends Node2D
@export_category("skeletons")
@export var skeleton_speed :float = 1000
@export var skele_speed_variance : float = 0.2
@export var max_skeletons: int = 128

@export_category("camera")
@export var min_zoom  :float = 0.5
@export var max_zoom :float = 1.5
@export var zoom_speed :float = 5.0

var camera_zoom := 1.0

const PICKUP = preload("res://scenes/pickup.tscn")

@onready var player: RigidBody2D = %Player
@onready var cursor: Sprite2D = $Cursor
@onready var camera: Camera2D = $Player/Camera2D
@onready var map_objects: Node2D = $"Map objects"
@onready var skeleton_group: MinionGroup = $Groups/SkeletonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	GlobalEvents.skeleton_pickup.connect(_on_pickup)
	GlobalEvents.item_dropped.connect(_on_item_drop)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel") ):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept") ):
		summon_skeleton(cursor.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skeleton_group.target.position = cursor.position
		
	camera_zoom = remap(skeleton_group.unit_count, 0, skeleton_group.max_units, max_zoom, min_zoom)
	camera.zoom = lerp(camera.zoom, Vector2.ONE * camera_zoom, delta*zoom_speed)
	
	$UILayer/Control/SkeletonCount.text = "skeleton count: " + str(skeleton_group.unit_count)
	%DebugLabel.text = Globals.debug_message

func _on_item_drop(pos: Vector2) ->void: 
	var d := PICKUP.instantiate()
	d.position = pos
	map_objects.add_child(d)

func _on_pickup(pos : Vector2) -> void:
	summon_skeleton(pos)

func summon_skeleton(pos: Vector2)-> void:
	skeleton_group.summon_unit(pos)
