extends Node2D

@export var lines: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is PlumbBob:
		DialogManager.start_dialog(global_position, lines)
