extends Node2D

var camera : FollowCamera

func _ready() -> void:
	camera = FollowCamera.new()
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
	camera.zoom = Vector2(0.9, 0.9)
	add_child(camera)
	$Rope.connect_rope_to_node($Player/Plumbbob)
	
func _process(delta):
	if Input.is_key_pressed(KEY_B):
		$Rope.disconnect_rope()
	
func _on_player_released_bob(plumbbob : PlumbBob) -> void:
	camera.set_target(plumbbob)
	camera.align()
	camera.set_offset(Vector2(0, 100))
	pass # Replace with function body.
