extends Node2D
@export var speed = 400 # How fast the player will move (pixels/sec).
var rigid_body

signal released_bob(plumbob : PlumbBob)

var plumb_bob : PlumbBob = null

var angle_speed : float = 0.05
var arrow : Sprite2D = null
var angle : float = 0
var orbit_radius : int = 50 
var direction : Vector2 = Vector2.ZERO
var launch_force = 0
var launch_inc = 10
var is_charging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow = $Arrow
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fishing_controls(delta)

func _physics_process(delta: float) -> void:
	steering_controls(delta)

func fishing_controls(delta):
	# Change trajectory
	if Input.is_action_pressed("move_up"):
		angle -= angle_speed
	if Input.is_action_pressed("move_down"):
		angle += angle_speed
	
	angle = clamp(angle, 0.0, PI/2)

	direction = Vector2.UP.rotated(angle).normalized()
	var orbit_position = direction * orbit_radius
	arrow.position = orbit_position
	arrow.rotation = angle
	
	# Charging logic
	if Input.is_action_just_pressed("fish"):
		is_charging = true
		launch_force = 0

	if is_charging and Input.is_action_pressed("fish"):
		launch_force += launch_inc

	if is_charging and Input.is_action_just_released("fish"):
		is_charging = false
		release_plumb_bob()

func release_plumb_bob():
	plumb_bob = load("res://scenes/plumbbob/plumbbob.tscn").instantiate()
	add_child(plumb_bob)  
	plumb_bob.global_position = self.global_position + Vector2(0.3,0.3)
	plumb_bob.launch(direction * launch_force)
	released_bob.emit(plumb_bob)
	pass

func steering_controls(delta):
	if (plumb_bob != null):
		if Input.is_action_pressed("move_left"):
			plumb_bob.steer(-1)
		if Input.is_action_pressed("move_right"):
			plumb_bob.steer(1)
