extends Node2D

var camera : FollowCamera

func _ready() -> void:
	camera = FollowCamera.new()
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
	add_child(camera)
	
func _on_player_released_bob(plumbbob : PlumbBob) -> void:
	camera.set_target(plumbbob)
	camera.align()
	camera.set_offset(Vector2(0, 100))
	pass # Replace with function body.
