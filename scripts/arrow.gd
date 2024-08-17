extends Node2D

@export var length :int = 7:
	set = set_length

@onready var arrow_back: Sprite2D = $ArrowBack
@onready var arrow_mid: Sprite2D = $ArrowMid
@onready var arrow_front: Sprite2D = $ArrowFront

@onready var back_width = arrow_back.get_rect().size.x
@onready var front_width = arrow_back.get_rect().size.x

func set_length(s:int) -> void:
	length = max(1,s)
	arrow_mid.scale.x = length
	arrow_front.position.x = back_width + length - front_width
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_length(length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
