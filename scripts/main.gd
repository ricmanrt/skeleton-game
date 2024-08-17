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

const SKELETON = preload("res://scenes/skeleton.tscn")

@onready var skeletons: Node2D = %Skeletons
@onready var player: RigidBody2D = %Player
@onready var cursor: Sprite2D = $Cursor
@onready var skeleton_average: Marker2D = $SkeletonAverage
@onready var arrow: Node2D = $SkeletonAverage/Arrow
@onready var camera: Camera2D = $Player/Camera2D

var skeleton_count = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	GlobalEvents.skeleton_pickup.connect(_on_pickup)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_cancel") ):
		get_tree().quit()
	if (event.is_action_pressed("ui_accept") ):
		summon_skeleton(cursor.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_zoom = remap(skeleton_count, 0, max_skeletons, max_zoom, min_zoom)
	camera.zoom = lerp(camera.zoom, Vector2.ONE * camera_zoom, delta*zoom_speed)
	
	$UILayer/Control/SkeletonCount.text = "skeleton count: " + str(skeleton_count)

func _physics_process(delta: float) -> void:
	move_skeletons(delta)

func _on_pickup(pos : Vector2) -> void:
	summon_skeleton(pos)

func summon_skeleton(pos: Vector2)-> void:
	if skeleton_count >= max_skeletons:
		#TODO: find the weakest skeleton and kill it
		skeletons.get_child(0).die()
	
	var s = SKELETON.instantiate()
	s.position = pos
	$SkeletonRaiseSound.pitch_scale = randf_range(0.7, 0.9)
	$SkeletonRaiseSound.play()
	skeletons.add_child.call_deferred(s)
	

func move_skeletons(delta: float) -> void:
	skeleton_count = skeletons.get_child_count()
	var avg_pos := Vector2.ZERO
	for s in skeletons.get_children():
		assert(s is RigidBody2D)
		var skeleton := s as RigidBody2D
		var direction := skeleton.position.direction_to(cursor.position)
		skeleton.apply_central_force(direction * skeleton_speed * delta * 20 )
		avg_pos+= skeleton.position
	avg_pos = avg_pos / skeleton_count
	
	skeleton_average.position = avg_pos
	skeleton_average.look_at(cursor.position)
	
	arrow.length = (avg_pos - cursor.position).length() - 32
