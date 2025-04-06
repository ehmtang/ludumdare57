extends Node2D

var timer : float = 0
var pause_time : float = 2
var player : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(player.plumb_bob.global_position)
	if (player.plumb_bob.global_position.x > 720):
		Global.game_controller.change_2d_scene("res://scenes/main/main.tscn")
		Global.game_controller.change_gui_scene("res://scenes/gui/gui.tscn")
	pass


	
