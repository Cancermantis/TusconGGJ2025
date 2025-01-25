extends Node3D

@export var seed := 1337
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = seed
	Globals.player = $Player
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_plants()

func _input(event):
	# Capture also on click because web.
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	pass

func spawn_plants():
	var saguaro := load("res://scenes/saguaro.tscn")
	var space_state := get_world_3d().direct_space_state
	for i in range(100):
		var pos := pick_pos()
		var plant: Node3D = saguaro.instantiate()
		plant.position += pos
		add_child(plant)

@onready var _space_state := get_world_3d().direct_space_state
@onready var _limit := Globals.bubble_size

func pick_pos() -> Vector3:
	var tries := 5
	for i in range(tries):
		var angle := rng.randf() * 2 * PI
		var limit := Globals.bubble_size
		var radius := rng.randf() * limit
		var pos := Vector3(cos(angle), 1, sin(angle)) * radius
		var to := pos + Vector3(0, -2 * limit, 0)
		var query := PhysicsRayQueryParameters3D.create(pos, to)
		var collision := _space_state.intersect_ray(query)
		if i == tries - 1 or collision["normal"].y < 0.8:
			# Rejection sampling against steep edges.
			continue
		return collision.get("position")
	# Shouldn't ever happen but required by static checking.
	return Vector3.ZERO
