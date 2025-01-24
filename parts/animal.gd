extends CharacterBody3D

@export var flee_distance: float = 20.0
@export var move_speed = 8.0

var change_delay: float
var heading: Vector2
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

var state: Callable = roam

var flight_angle = 70.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pick_heading()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state.call(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func roam(delta: float) -> void:
	change_delay -= delta
	if change_delay < 0:
		pick_heading()
	position = Globals.keep_in_bubble(position)
	var move := heading #* delta
	velocity = Vector3(move.x, velocity.y, move.y)
	update_facing()

func pick_heading() -> void:
	change_delay = randf_range(1.0, 5.0)
	if randf() < 0.3:
		sprite.stop()
		heading = Vector2.ZERO
	else:
		sprite.play()
		heading = 2 * (Vector2(randf(), randf()) - Vector2.ONE * 0.5)

func update_facing() -> void:
	if heading == Vector2.ZERO:
		return
	var player_to_self_3d := Globals.player.position - position
	var player_to_self := Vector2(player_to_self_3d.x, player_to_self_3d.z)
	var angle = heading.angle_to(player_to_self)
	sprite.flip_h = angle < 0

func flee(delta: float) -> void:
	var distance = Globals.player.global_position.distance_to(self.global_position)
	if(distance >= flee_distance):
		pick_heading()
		velocity = Vector3.ZERO
		$SoundReceiver.triggered = false
		state = roam
		return
	
	position = Globals.keep_in_bubble(position)
	var direction = Globals.player.global_position.direction_to(self.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	
	# the more aligned the calculated is with the player's facing, the more we rotate the direction away from that facing
	var rotation_factor: float = max(direction.dot(-Globals.player.global_basis.z), 0)
	var left_right = -sign(direction.dot(Globals.player.global_basis.x))
	if(left_right == 0):
		left_right = 1
	
	print(rotation_factor)
	#direction = direction.rotated(Vector3.UP, (rotation_factor * flight_angle * left_right))
	
	var desired_velocity = direction * move_speed
	desired_velocity.y = velocity.y
	velocity = desired_velocity
	heading = Vector2(velocity.x, velocity.z)
	update_facing()

func _on_sound_received() -> void:
	sprite.play()
	state = flee
