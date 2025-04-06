extends Node2D

var camera : FollowCamera

func _ready() -> void:
	camera = FollowCamera.new()
	camera.set_anchor_mode(Camera2D.ANCHOR_MODE_DRAG_CENTER)
	camera.zoom = Vector2(0.9, 0.9)
	add_child(camera)
	var rope_player_join = PinJoint2D.new()
	add_child(rope_player_join)
	rope_player_join.position = $Rope.get_end_position()
	rope_player_join.node_a = $Rope.get_end_body().get_path()
	rope_player_join.node_b = $Player/Plumbbob.get_path()
	
func _on_player_released_bob(plumbbob : PlumbBob) -> void:
	camera.set_target(plumbbob)
	camera.align()
	camera.set_offset(Vector2(0, 100))
	pass # Replace with function body.
