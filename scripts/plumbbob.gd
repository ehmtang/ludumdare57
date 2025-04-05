extends RigidBody2D
class_name  PlumbBob

var steer_value : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launch(value : Vector2) -> void:
	linear_velocity = value
	angular_velocity = 0.6

func steer(value : float):
	steer_value += value

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	apply_torque(steer_value)
	apply_central_force(global_transform.basis_xform(Vector2(0,100)))
