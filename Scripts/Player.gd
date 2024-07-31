extends CharacterBody3D

@onready var player_cam : Camera3D = $Camera3D
@onready var shooting_ray : RayCast3D = $Camera3D/RayCast3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed : float = 6.0
@export var sprint_speed : float = 11
@export var jump_velocity : float = 4.5
@export var mouse_sensitive : float = 0.4

var original_speed : float
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_shooting : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	original_speed = speed

func _process(_delta: float) -> void:
	_cursor_handle()
	
	# Gun logic
	if Input.is_action_just_pressed("fire") and not is_shooting:
		_shoot()
	elif not is_shooting:
		animation_player.play("gun_idle")
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle move
	_move()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sensitive))
		player_cam.rotate_x(-deg_to_rad(event.relative.y * mouse_sensitive))
		player_cam.rotation.x = clamp(player_cam.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
func _cursor_handle() -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _move() -> void:
	# Handle jump.
	if Input.is_action_just_pressed("key_jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_key_pressed(KEY_SHIFT):
		speed = sprint_speed
	else:
		speed = original_speed
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _shoot() -> void:
	is_shooting = true
	if shooting_ray.is_colliding():
		const MUZZLE = preload("res://Scenes/muzzle_flash.tscn")
		var cur_muzzle := MUZZLE.instantiate()
		shooting_ray.get_collider().add_child(cur_muzzle)
		cur_muzzle.global_transform.origin = shooting_ray.get_collision_point()
		cur_muzzle.look_at(global_position)
	animation_player.play("gun_shoot")
	await animation_player.animation_finished
	is_shooting = false
