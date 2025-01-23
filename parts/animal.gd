extends CharacterBody3D

var change_delay: float
var heading: Vector2
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pick_heading()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_delay -= delta
	if change_delay < 0:
		pick_heading()
	position = Globals.keep_in_bubble(position)
	var move := heading #* delta
	velocity = Vector3(move.x, velocity.y, move.y)
	update_facing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

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
