extends Node2D
var rigid_body

signal released_bob(plumbob : PlumbBob)
signal position_changed(new_position: Vector2)


var plumb_bob : PlumbBob = null

var angle_speed : float = 0.05
var arrow : Sprite2D = null
var angle : float = 0
var orbit_radius : int = 50 
var direction : Vector2 = Vector2.ZERO
var launch_force = 0
var launch_inc = 1000
var launch_min = 0
var launch_max = 2000
var is_charging : bool = false
var plumb_bob_launched = false
var progress_bar : ProgressBar = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow = $Arrow
	progress_bar = $Charge
	plumb_bob = $Plumbbob
	progress_bar.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("position_changed", plumb_bob.global_position)
	fishing_controls(delta)

func _physics_process(delta: float) -> void:
	steering_controls(delta)

func fishing_controls(delta):
	# Skip if launched
	if plumb_bob_launched:
		return
	# Change trajectory
	if not is_charging:
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
		progress_bar.visible = true
		launch_force = 0

	if is_charging and Input.is_action_pressed("fish"):
		progress_bar.value += delta
		launch_force += launch_inc * delta
		launch_force = clamp(launch_force, launch_min, launch_max)

	if is_charging and Input.is_action_just_released("fish"):
		is_charging = false
		progress_bar.visible = false
		progress_bar.value = 0
		release_plumb_bob()

func release_plumb_bob():
	plumb_bob.launch(direction * launch_force)
	plumb_bob_launched=true
	released_bob.emit(plumb_bob)
	$JumpAudio.play()
	pass

func steering_controls(delta):
	if (plumb_bob_launched):
		if Input.is_action_pressed("move_left"):
			plumb_bob.steer(-1)
		if Input.is_action_pressed("move_right"):
			plumb_bob.steer(1)
