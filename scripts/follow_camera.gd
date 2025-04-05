extends Camera2D

class_name FollowCamera

var follow_target : Node2D
var f = 0.3

func set_target(target : Node2D):
	follow_target = target
	
func clear_target():
	follow_target = null
	
func _process(delta):
	if (follow_target != null):
		set_global_position(global_position * (1.0 - f) + f *follow_target.get_global_position())
