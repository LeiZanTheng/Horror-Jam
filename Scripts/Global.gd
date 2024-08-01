# WARNING : SPAGHETTI CODE
# Bro got no time for optimization OR better paradigm
extends Node

var player : CharacterBody3D
var player_pos : Vector3
var in_shooting_area : bool = false
var headshot_counter : int = 0
var is_in_event : bool = false
var event_player : AnimationPlayer
var phase : int = 1
var teleport_des : Vector3 = Vector3(42, 2, -828)
var return_des : Vector3 = Vector3(17, 2, -3)
# Event handle SHIT SHIT SHIT SHIT SHIT SHIT

func _process(delta: float) -> void:
	if headshot_counter >= 3 and phase == 1:
		_jumpscare_1()
		
# First jumpscare
func _jumpscare_1() -> void:
	phase += 1
	is_in_event = true
	player.global_rotation = Vector3(0, 0, 0)
	event_player.play("jumpscare1")
	await event_player.animation_finished
	is_in_event = false
	_jumpscare_trans_1_to_2()

func _jumpscare_trans_1_to_2() -> void:
	await get_tree().create_timer(20).timeout
	_jumpscare_2()

func _jumpscare_2() -> void:
	phase += 1
	is_in_event = true
	player.global_position = teleport_des
	is_in_event = false
