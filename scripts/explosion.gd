extends Area2D

@export var damage  := 1
@export var impulse := 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for b in get_overlapping_bodies():
		if b is RigidBody2D:
			var dir := self.position.direction_to(b.position) 
			var distance_mod := 1 - 1/self.position.distance_squared_to(b.position)
			b.apply_central_impulse( impulse  *   dir * distance_mod  )
		
		queue_free()
