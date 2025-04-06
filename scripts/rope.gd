extends Node2D
class_name Rope

var segments = Array([], TYPE_OBJECT, "RigidBody2D", null)


func _ready() -> void:
	segments.append($RopeSegment)
	segments.append($RopeSegment2)
	segments.append($RopeSegment3)
	segments.append($RopeSegment4)
	
