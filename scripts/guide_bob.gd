extends Node2D

@export var lines: Array[String] = []
@export var bob_texture: Texture2D

@onready var sprite = $Sprite2D

func _ready() -> void:
	if bob_texture:
		sprite.texture = bob_texture

	var area = $Area2D
	area.connect("body_entered", Callable(self, "_on_body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is PlumbBob:
		DialogManager.start_dialog(global_position, lines)
