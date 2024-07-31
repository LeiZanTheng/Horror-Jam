extends Node3D

func _head_shot_handle() -> void:
	if Global.in_shooting_area:
		Global.headshot_counter += 1
