extends Control

@onready var position_label: Label = $Label
@onready var player = get_node("/root/GameController/World2D/Main/Player")

func _ready():
	player.position_changed.connect(_on_player_position_changed)

func _on_player_position_changed(pos: Vector2):
	position_label.text = "Position: (%.1f, %.1f)" % [pos.x, pos.y]
