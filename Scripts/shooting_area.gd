extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is PLAYER:
		Global.in_shooting_area = true

func _on_body_exited(body: Node3D) -> void:
	if body is PLAYER:
		Global.in_shooting_area = false
