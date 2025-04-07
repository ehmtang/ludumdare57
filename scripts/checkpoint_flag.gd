extends Area2D
class_name Checkpoint

#signal checkpoint_activated(checkpoint : Checkpoint)
@export var checkpoint_id : int = 0
@export var rope_length : int = 10 #ROPE LENGTH MUST BE EVEN SO THIS IS MULTIPLIED BY 2
enum ActiveState {INACTIVE, USED, ACTIVE}

var checkpoint_positions: Array = []
var checkpoint_marker_scene: PackedScene = preload("res://scenes/checkpoint_flag/checkpoint_flag.tscn")
var active_state : ActiveState = ActiveState.INACTIVE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Rope.length = rope_length*2
	reset_rope()
	set_active_state(ActiveState.INACTIVE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_rope():
	$Rope.reset_rope()
	
func get_rope() -> Rope:
	return $Rope
	
func get_anchor():
	return $Anchor	

func set_active_state(state : ActiveState):
	active_state = state
	match active_state:
		ActiveState.INACTIVE:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_inactive.png")
		ActiveState.USED:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_used.png")
		ActiveState.ACTIVE:
			$Sprite2D.texture = load("res://assets/art/icons/checkpoint_flag_active.png")


func _on_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		var rb : RigidBody2D = body
		if (rb.get_parent().get("is_player")): 
			rb.get_parent().area_entered.emit(self)
