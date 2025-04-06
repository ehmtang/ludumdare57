extends Node2D

@onready var player = get_node("/root/GameController/World2D/Main/Player")
var checkpoint_positions: Array = []
var checkpoint_marker_scene: PackedScene = preload("res://scenes/checkpoint_flag/checkpoint_flag.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
