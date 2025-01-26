class_name Player
extends CharacterBody3D

const SPEED_QUIET := 1.0
const SPEED := 5.0
const SPEED_SPRINT := 10.0
const JUMP_VELOCITY := 4.5
const LOOK_SPEED := 2.0
@export var mouse_sensitivity := 5e-3
@onready var camera: Camera3D = $Camera3D
@onready var broadcaster: SoundBroadcaster = $SoundBroadcaster
@onready var limited_audio_stream_player: LimitedAudioStreamPlayer = $LimitedAudioStreamPlayer

var stealth: bool = false
var sprinting: bool = false
var current_max_speed = SPEED
@export var input_disabled = true

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if(input_disabled):
		return
	
	if(event.is_action_pressed("stealth") && !sprinting):
		stealth = true
		current_max_speed = SPEED_QUIET
	elif(event.is_action_released("stealth") && stealth):
		stealth = false
		current_max_speed = SPEED
	if(event.is_action_pressed("sprint") && !stealth):
		sprinting = true
		current_max_speed = SPEED_SPRINT
	elif(event.is_action_released("sprint") && sprinting):
		sprinting = false
		current_max_speed = SPEED

func _process(delta: float) -> void:
	if(Globals.ui_mode):
		return
	var mouse_delta := Input.get_last_mouse_velocity()
	
	if(mouse_delta != Vector2.ZERO):
		rotate_y(-mouse_delta.x * mouse_sensitivity * delta)
		camera.rotate_x(-mouse_delta.y * mouse_sensitivity * delta)
	else:
		var joystick_cam = -Input.get_vector("look_left", "look_right", "look_up", "look_down")
		rotate_y(joystick_cam.x * LOOK_SPEED * delta)
		camera.rotate_x(joystick_cam.y * LOOK_SPEED * delta)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)
	
	if(!input_disabled):
		position = Globals.keep_in_bubble(position)

func _physics_process(delta: float) -> void:
	if(input_disabled):
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if bounce_time > 0:
		bounce = bounce.normalized()
		direction.x = bounce.x
		direction.z = bounce.y
		bounce_time -= delta
	else:
		bounce = Vector2.ZERO
	if direction:
		velocity.x = direction.x * current_max_speed
		velocity.z = direction.z * current_max_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_max_speed)
		velocity.z = move_toward(velocity.z, 0, current_max_speed)
	broadcaster.base_volume = velocity.length() / SPEED
	if move_and_slide():
		check_collisions()

var bounce := Vector2.ZERO
var bounce_time := 0.0

func check_collisions() -> void:
	# Just check for thorns for now.
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.is_in_group("thorn"):
			Globals.hit_thorn.emit()
			limited_audio_stream_player.play()
			var dir: Vector3 = position - collider.position
			bounce += Vector2(dir.x, dir.y).normalized()
			bounce_time = 0.2
			# Doesn't matter how many.
			break
