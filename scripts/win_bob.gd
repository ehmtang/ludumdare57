extends Node2D

var lines : Array[String] = [
	"Hey Plum, thanks for getting me.",
	"I was getting lonely..."
]

var dialog_triggered : bool = false
var timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	timer = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dialog_triggered:
		return
		
	timer += delta
	pass


func _on_body_entered(body: Node) -> void:
	if !dialog_triggered and body is PlumbBob:
		dialog_triggered = true
		
		var line = ""
		if timer >= 60.0:
			var minutes := int(timer) / 60
			var seconds := int(timer) % 60
			line = "It took you: %d minute(s) and %02d second(s)" % [minutes, seconds]
		else:
			line = "It took you: %.1f seconds" % timer
		
		lines.append(line)
		lines.append("Let's go home and have some cocoa.")
		
		DialogManager.dialog_finished.connect(_on_dialog_finished)
		DialogManager.start_dialog(global_position, lines)

func _on_dialog_finished():
	DialogManager.dialog_finished.disconnect(_on_dialog_finished)
	Global.game_controller.remove_gui_scene()
	Global.game_controller.change_2d_scene("res://scenes/game_over/game_over.tscn")
