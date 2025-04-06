extends Node2D

var camera : FollowCamera

func _ready() -> void:
	camera = FollowCamera.new()
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
	camera.zoom = Vector2(0.9, 0.9)
	add_child(camera)
	$Player.add_checkpoint($CheckpointFlag_Start)
	$Player.return_to_last_checkpoint()
	$CheckpointFlag_Start.set_active_state(Checkpoint.ActiveState.INACTIVE)
func _process(delta):
	pass
	
func _on_player_released_bob(plumbbob : PlumbBob) -> void:
	camera.set_target(plumbbob)
	camera.align()
	camera.set_offset(Vector2(0, 100))

func _on_player_checkpoint_requested(position: Vector2) -> void:
	#TODO : check for positioning
	var new_flag = load("res://scenes/checkpoint_flag/checkpoint_flag.tscn").instantiate()
	new_flag.position=position
	add_child(new_flag)
	$Player.get_checkpoints()[-1].get_rope().disconnect_rope()
	$Player.add_checkpoint(new_flag)
	$Player.return_to_last_checkpoint()
	
func _on_player_checkpoint_triggered(checkpoint : Checkpoint): #checkpoint used
	var player : Player
	player = $Player
	var plumbbob : RigidBody2D
	plumbbob = $Player/Plumbbob
	plumbbob.freeze=true
	player.get_node("Plumbbob").global_position = checkpoint.position
	plumbbob.rotation=0.0
	plumbbob.linear_velocity=Vector2.ZERO
	player.return_to_stationary()
	checkpoint.get_rope().disconnect_rope()
	checkpoint.reset_rope()
	checkpoint.get_rope().connect_rope_to_node($Player/Plumbbob)
