extends Node2D
class_name Rope

@onready var segments = Array([], TYPE_OBJECT, "RigidBody2D", null)
@onready var joints = Array([], TYPE_OBJECT, "PinJoint2D", null)
var end_joint : PinJoint2D
@onready var segment_scene = preload("res://scenes/rope/rope_segment.tscn")
@export var length = 5
@export var segment_length = 10.0

func _ready() -> void:
	#reset_rope()
	pass
	
func reset_rope():
	disconnect_rope()
	for segment in segments:
		segment.queue_free()
	segments.clear()
	
	for joint in joints:
		joint.queue_free()
	joints.clear()
	#print_tree_pretty()
	if length >= 1:
		var new_segment = segment_scene.instantiate()
		add_child(new_segment)
		var new_joint = PinJoint2D.new()
		add_child(new_joint)
		new_segment.position = Vector2.ZERO
		new_segment.rotation = -PI/2
		new_joint.position = Vector2.ZERO
		new_joint.node_a = $RopeTop.get_path()
		new_joint.node_b = new_segment.get_path()
		segments.append(new_segment)
		joints.append(new_joint)
	
	if length >= 2:
		for i : int in range(length - 1):
			var new_segment = segment_scene.instantiate()
			add_child(new_segment)
			new_segment.position = segments.back().position + Vector2.DOWN.rotated(segments.back().rotation) * segment_length
			new_segment.rotation = PI * ((i+1)%2) - PI/2
			var new_joint = PinJoint2D.new()
			#new_joint.bias = 1.0
			add_child(new_joint)
			new_joint.position = segments.back().position + Vector2.DOWN.rotated(segments.back().rotation) * segment_length
			segments.push_back(new_segment)
			new_joint.node_a = segments[-2].get_path()
			new_joint.node_b = segments[-1].get_path()
			joints.push_back(new_joint)
	

func _process(delta):
	pass

func get_end_position():
	return segments[-1].global_position + Vector2.DOWN.rotated(segments[-1].rotation) * segment_length
	
func get_end_body():
	return segments[-1]
	#
func disconnect_rope():
	if (end_joint != null):
		end_joint.queue_free()
		end_joint = null	

func connect_rope_to_node(node : Node2D):
	disconnect_rope()
	var new_joint = PinJoint2D.new()
	add_child(new_joint)
	new_joint.position = segments.back().position + Vector2.DOWN.rotated(segments.back().rotation) * segment_length
	new_joint.node_a = segments[-1].get_path()
	new_joint.node_b = node.get_path()
	end_joint = new_joint
