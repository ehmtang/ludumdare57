extends Node2D

var timer : float = 0
var pause_time : float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > pause_time:
		Global.game_controller.change_2d_scene("res://scenes/main/main.tscn")
	pass
