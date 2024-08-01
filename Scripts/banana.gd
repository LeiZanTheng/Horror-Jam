extends Area3D
@onready var event_player: AnimationPlayer = $"../../../EventPlayer"

func _on_body_entered(body: Node3D) -> void:
	if body is PLAYER:
		body.global_position = Global.return_des
		event_player.play("jumpscare2")
