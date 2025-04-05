extends Node2D
@export var speed = 400 # How fast the player will move (pixels/sec).
var rigid_body

signal released_bob(plumbob : PlumbBob)

var screen_size # Size of the game window.
var velocity = Vector2.ZERO # The player's movement vector.
var plumb_bob : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if Input.is_action_just_pressed("fish"):
		release_plumb_bob()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed   
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func release_plumb_bob():
	plumb_bob = load("res://scenes/plumbbob/plumbbob.tscn").instantiate()
	add_child(plumb_bob)  
	plumb_bob.global_position = self.global_position + Vector2(0.3,0.3)
	released_bob.emit(plumb_bob)
	pass
