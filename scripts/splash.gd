extends Node2D

var lines : Array[String] = [
	"aaaaaAAAAAAaaaaaaaaa!",
	"... Hey Plum... Could you come get me?",
	"It's cold and wet down here."
]

var timer : float = 0
var pause_time : float = 2
var plumb_bob : Node2D = null
var dialog_started: bool

var anim_played : bool
var is_dialog_finished : bool = false

@onready var plum = $GuideBob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plumb_bob = $Player/Plumbbob
	plumb_bob.get_child(0).visible = false
	plumb_bob.get_child(1).visible = true
	DialogManager.dialog_finished.connect(_on_dialog_finished)
	dialog_started = false
	anim_played = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!dialog_started and plumb_bob.global_position.x > 720):
		dialog_started = true
		DialogManager.start_dialog(Vector2(550,350), lines)	

	if is_dialog_finished:
		plum.global_position.x += 8
		if plum.global_position.x > 760:
			Global.game_controller.change_2d_scene("res://scenes/main/main.tscn")
			Global.game_controller.change_gui_scene("res://scenes/gui/gui.tscn")
	

func _on_dialog_finished():
	DialogManager.dialog_finished.disconnect(_on_dialog_finished)
	is_dialog_finished = true
