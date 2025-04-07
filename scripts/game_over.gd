extends Node2D

var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 5 and Input.is_action_just_pressed("fish"):
		Global.game_controller.change_2d_scene("res://scenes/splash/splash.tscn")
