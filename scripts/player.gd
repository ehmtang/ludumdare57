extends Node2D
@export var speed = 400 # How fast the player will move (pixels/sec).
var rigid_body

signal released_bob(plumbob : PlumbBob)

var screen_size # Size of the game window.
var velocity = Vector2.ZERO # The player's movement vector.
var plumb_bob : Node2D = null

var angle_speed : float = 0.05
var arrow : Sprite2D = null
var angle : float = 0
var orbit_radius : int = 50 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	arrow = $Arrow
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fishing_controls()
	steering_controls()

func fishing_controls():
	# Change trajectory
	if Input.is_action_pressed("move_up"):
		angle -= angle_speed
	if Input.is_action_pressed("move_down"):
		angle += angle_speed

	var orbit_position = Vector2.UP.rotated(angle) * orbit_radius
	arrow.position = orbit_position
	arrow.rotation = angle
	
	if Input.is_action_just_pressed("fish"):
		release_plumb_bob()

func release_plumb_bob():
	plumb_bob = load("res://scenes/plumbbob/plumbbob.tscn").instantiate()
	add_child(plumb_bob)  
	plumb_bob.global_position = self.global_position + Vector2(0.3,0.3)
	released_bob.emit(plumb_bob)
	pass

func steering_controls():
	if (plumb_bob != null):
		if Input.is_action_pressed("move_left"):
			plumb_bob.steer(-2000)
		if Input.is_action_pressed("move_right"):
			plumb_bob.steer(2000)
