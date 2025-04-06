extends Node2D

var lines : Array[String] = [
	"aaaaaAAAAAAaaaaaaaaa",
	"...",
	"... Hey Plum... Could you come get me?",
	"It's cold and wet."
]

var timer : float = 0
var pause_time : float = 2
var plumb_bob : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plumb_bob = $Player/Plumbbob
	plumb_bob.get_child(0).visible = false
	plumb_bob.get_child(1).visible = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (plumb_bob.global_position.x > 720):
		Global.game_controller.change_2d_scene("res://scenes/main/main.tscn")
		Global.game_controller.change_gui_scene("res://scenes/gui/gui.tscn")
	pass


	
