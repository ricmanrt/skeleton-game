# Cursor
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween_animation()
	pass

func tween_animation() -> void:
	scale = Vector2(1,1)
	var tween = create_tween().tween_property(self,"scale", Vector2(0.7,0.7), 1).set_ease(Tween.EASE_OUT)
	tween.connect("finished", tween_animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()
	
