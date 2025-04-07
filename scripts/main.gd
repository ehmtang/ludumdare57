extends Node2D

var camera : FollowCamera

func _ready() -> void:
	camera = FollowCamera.new()
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
	camera.zoom = Vector2(0.9, 0.9)
	add_child(camera)
	$Player.plumb_bob.get_child(0).visible = true
	$Player.plumb_bob.get_child(1).visible = false
	camera.set_target($Player/Plumbbob)
	camera.align()
	camera.set_offset(Vector2(0, 100))
	$Player.checkpoint_activated.emit($CheckpointFlag_Start)
	
func _process(delta):
	pass
	
func _on_player_released_bob(plumbbob : PlumbBob) -> void:
	pass
	
func _on_player_checkpoint_requested(req_position: Vector2) -> void: #make a new cp / broken DON'T USE
	#TODO : check for positioning
	var new_flag = load("res://scenes/checkpoint_flag/checkpoint_flag.tscn").instantiate()
	new_flag.position=req_position
	add_child(new_flag)
	$Player.checkpoint_activated.emit(new_flag) # Player activates this checkpoint
	
func _on_player_checkpoint_activated(checkpoint : Checkpoint): # when touched
	if $Player.get_checkpoints().size() > 0:
		#$Player.get_checkpoints()[-1].get_rope().disconnect_rope() # clean up last cp
		if ($Player.checkpoints.size() > 0):
			$Player.checkpoints[-1].set_active_state(Checkpoint.ActiveState.USED)
	
	#setup new cp
	checkpoint.set_active_state(Checkpoint.ActiveState.ACTIVE)
	$Player.add_checkpoint(checkpoint)
	$Player.return_to_last_checkpoint() #instantly triggers
	
func _on_player_checkpoint_triggered(checkpoint : Checkpoint): #when return to cp
	var player : Player
	player = $Player
	player.freeze_and_goto_position(checkpoint.get_anchor().global_position)
	checkpoint.get_rope().disconnect_rope()
	player.goto_checkpoint = checkpoint

func _on_player_goto_arrive() -> void:
	if ($Player.goto_checkpoint != null):
		var checkpoint = $Player.goto_checkpoint
		if $Player.get_checkpoints().size() >= 2:
			var old_checkpoint = $Player.get_checkpoints()[-2] # reattach old rope to new flag
			old_checkpoint.get_rope().connect_rope_to_node(checkpoint.get_anchor())
		checkpoint.reset_rope()
		checkpoint.get_rope().connect_rope_to_node($Player/Plumbbob)
