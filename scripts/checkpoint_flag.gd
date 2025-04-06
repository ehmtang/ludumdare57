extends Node2D
class_name Checkpoint

signal checkpoint_activated(checkpoint : Checkpoint)

enum ActiveState {INACTIVE, USED, ACTIVE}

var checkpoint_positions: Array = []
var checkpoint_marker_scene: PackedScene = preload("res://scenes/checkpoint_flag/checkpoint_flag.tscn")
var active_state : ActiveState = ActiveState.INACTIVE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_rope()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_rope():
	$Rope.reset_rope()
	
func get_rope() -> Rope:
	return $Rope
	
func set_active_state(state : ActiveState):
	active_state = state
	match active_state:
		ActiveState.INACTIVE:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_inactive.png")
		ActiveState.USED:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_used.png")
		ActiveState.ACTIVE:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_active.png")
