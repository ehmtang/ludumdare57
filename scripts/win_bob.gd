extends Node2D

var lines : Array[String] = [
	"Hey Plum, thanks for getting me.",
	"I was getting lonely...",
	"Let's go home and have some cocoa."
]

var dialog_triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if !dialog_triggered and body is PlumbBob:
		dialog_triggered = true
		DialogManager.dialog_finished.connect(_on_dialog_finished)
		DialogManager.start_dialog(global_position, lines)

func _on_dialog_finished():
	DialogManager.dialog_finished.disconnect(_on_dialog_finished)
	Global.game_controller.remove_gui_scene()
	Global.game_controller.change_2d_scene("res://scenes/game_over/game_over.tscn")
