class_name GameController extends Node

@export var world_3d : Node3D
@export var world_2d : Node2D
@export var gui : Control

var current_3d_scene : Node3D = null
var current_2d_scene : Node2D = null
var current_gui_scene : Control = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	change_2d_scene("res://scenes/splash/splash.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new


func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var new = load(new_scene).instantiate()
	$World2D.add_child(new)
	current_2d_scene = new
