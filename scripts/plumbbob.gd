extends RigidBody2D
class_name  PlumbBob

var steer_value : float
@export var drag_value : float
@export var perp_drag_value : float
@export var accel_force :  float
@export var steer_factor :  float

var dir = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sleeping = false
	freeze = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launch(value : Vector2) -> void:
	linear_velocity = value
	angular_velocity = 0.0
	rotation = value.angle() + PI/2.0
	freeze = false

func steer(value : float):
	steer_value += value

#func _draw():
	#draw_circle(Vector2.ZERO, 20, Color.RED)
	#draw_circle(dir*100, 20, Color.BLUE)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.apply_torque(steer_value * steer_factor)
	steer_value = 0
	var vel = state.linear_velocity
	var dir = state.transform.basis_xform(Vector2.UP)
	var dir_perp = state.transform.basis_xform(Vector2.LEFT)

	state.apply_central_force(accel_force * dir)
	state.apply_central_force(-dir.dot(vel) * dir * drag_value)
	state.apply_force(-dir_perp.dot(vel) * dir_perp * perp_drag_value, -dir * 1.0)
	#draw_line(state.transform.get_origin(), state.transform.get_origin()+dir, Color.AQUA)
	
