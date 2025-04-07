extends Node2D
class_name Player
var rigid_body

signal released_bob(plumbob : PlumbBob)

signal position_changed(new_position: Vector2)
signal checkpoint_requested(position: Vector2)
signal checkpoint_activated(checkpoint : Checkpoint)
signal checkpoint_triggered(checkpoint : Checkpoint)
signal area_entered(area : Area2D)
signal goto_arrive()

var goto_checkpoint : Checkpoint

var is_player : bool = true # just so can be idd as player in collisions by flags

var plumb_bob : PlumbBob = null

var angle_speed : float = 0.05
var arrow : Sprite2D = null
var launch_angle : float = 0
var orbit_radius : int = 50 
var direction : Vector2 = Vector2.ZERO
var launch_force = 0
var launch_inc = 1000
var launch_min = 0
var launch_max = 500
var is_charging : bool = false
var plumb_bob_launched = false
var progress_bar : ProgressBar = null

var last_position: Vector2
var checkpoints : Array = []

var goto_mode : bool
var goto_target : Vector2
var goto_start : Vector2
var goto_start_angle : float
var goto_lerp : float
var goto_rate : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow = $Plumbbob/Arrow
	progress_bar = $Plumbbob/Charge
	plumb_bob = $Plumbbob
	progress_bar.visible = false
	last_position = plumb_bob.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("position_changed", plumb_bob.global_position)
	fishing_controls(delta)

	if Input.is_action_just_pressed("restore_checkpoint") && !goto_mode:
		return_to_last_checkpoint()

func _physics_process(delta: float) -> void:
	if (goto_mode):
		var tlerp = -(cos(PI * goto_lerp) - 1) / 2
		plumb_bob.global_position = (1.0 - tlerp)*goto_start + tlerp*goto_target
		plumb_bob.global_rotation = (1.0 - tlerp)*goto_start_angle
		
		goto_lerp += goto_rate * delta
		if goto_lerp >= 1.0:
			goto_arrive.emit()
	else:
		steering_controls(delta)
		last_position = plumb_bob.global_position

func fishing_controls(delta):
	# Skip if launched
	if plumb_bob_launched:
		return
	
	if goto_mode:
		return
		
	# Create a checkpoint to return to if player becomes stuck
	if Input.is_action_just_pressed("store_checkpoint"):
		checkpoint_requested.emit(plumb_bob.global_position)
		
	# Change trajectory
	if not is_charging:
		if Input.is_action_pressed("move_up"):
			launch_angle -= angle_speed
		if Input.is_action_pressed("move_down"):
			launch_angle += angle_speed
	
	launch_angle = clamp(launch_angle, -PI/2, PI/2)
	direction = Vector2.UP.rotated(launch_angle).normalized()
	var orbit_position = direction * orbit_radius
	arrow.position = orbit_position
	arrow.rotation = launch_angle
	
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
		release_plumb_bob()

func release_plumb_bob():
	is_charging = false
	progress_bar.visible = false
	arrow.visible = false
	$Plumbbob.freeze = false
	progress_bar.value = 0
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
		return_to_stationary()

func return_to_stationary():
	var world_up = Vector2.UP
	var player_up = Vector2.UP.rotated(plumb_bob.global_rotation).normalized()
	var alignment = world_up.dot(player_up)
	var is_stationary = plumb_bob.linear_velocity.length_squared() < 0.1
	var is_standing_upright = (1 - alignment < 0.1 and alignment > 0)
	
	if is_stationary and is_standing_upright:
		freeze_here()
	
	if is_stationary and not is_standing_upright:
		if Input.is_action_pressed("fish"):
			plumb_bob.linear_velocity = Vector2(0,-350)

func freeze_player():
	plumb_bob.freeze = true

func freeze_here():
	freeze_player()
	launch_mode()

func freeze_and_goto_position(new_position : Vector2):
	freeze_player()
	goto_mode = true
	goto_target = new_position
	goto_lerp = 0.0
	goto_start_angle = plumb_bob.rotation
	goto_start = plumb_bob.global_position

func launch_mode():
	plumb_bob_launched = false
	plumb_bob.rotation = 0.0
	arrow.visible = true
	plumb_bob.linear_velocity = Vector2.ZERO

func add_checkpoint(checkpoint : Checkpoint):
	checkpoints.push_back(checkpoint)

func get_checkpoints():
	return checkpoints

func set_checkpoints(_checkpoints):
	checkpoints = _checkpoints.duplicate()

func return_to_last_checkpoint():
	if (checkpoints.size() > 0):
		checkpoint_triggered.emit(checkpoints[-1])

func _on_area_entered(area: Area2D) -> void:
	if ( area.get("checkpoint_id") != null && !goto_mode):
		var checkpoint : Checkpoint = area
		if (checkpoint.active_state == Checkpoint.ActiveState.INACTIVE):
			checkpoint_activated.emit(checkpoint)
			

func _on_goto_arrive() -> void:
	goto_mode=false
	launch_mode()
