extends RigidBody2D
class_name  PlumbBob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2(200,-500)
	angular_velocity = 0.6
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
