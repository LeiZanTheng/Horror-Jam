extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is PLAYER:
		body.global_position = Global.return_des
