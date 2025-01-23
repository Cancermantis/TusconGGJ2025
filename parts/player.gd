extends CharacterBody3D


var bubble_size := 49
const SPEED := 5.0
const JUMP_VELOCITY := 4.5
@export var mouse_sensitivity := 5e-3
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	var mouse_delta := Input.get_last_mouse_velocity()
	rotate_y(-mouse_delta.x * mouse_sensitivity * delta)
	self.camera.rotate_x(-mouse_delta.y * mouse_sensitivity * delta)
	self.camera.rotation_degrees.x = clamp(self.camera.rotation_degrees.x, -80, 80)
	var distance := position.length()
	if distance > bubble_size:
		position = position.normalized() * bubble_size


func _physics_process(delta: float) -> void:
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
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
