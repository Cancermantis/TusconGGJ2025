extends Node3D

func _ready() -> void:
	Globals.player = $Player
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_plants()

func _input(event):
	# Capture also on click because web.
	if event is InputEventMouseButton and event.pressed && !Globals.ui_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	pass

func spawn_plants():
	var space_state := get_world_3d().direct_space_state
	var cholla := preload("res://scenes/cholla.tscn")
	var ocotillo := preload("res://scenes/ocotillo.tscn")
	var mesquite := preload("res://scenes/mesquite.tscn")
	var pear := preload("res://scenes/pear.tscn")
	var poppy := preload("res://scenes/poppy.tscn")
	var rock := preload("res://scenes/rock.tscn")
	var saguaro := preload("res://scenes/saguaro.tscn")
	var saguaro_dead := preload("res://scenes/saguaro_dead.tscn")
	var saguaro_small := preload("res://scenes/saguaro_small.tscn")
	for i in range(200):
		spawn_plant(cholla)
	for i in range(20):
		spawn_plant(mesquite)
	for i in range(100):
		spawn_plant(ocotillo)
	for i in range(300):
		spawn_plant(pear)
	for i in range(100):
		spawn_plant(poppy)
	for i in range(50):
		spawn_plant(rock)
	for i in range(40):
		spawn_plant(saguaro)
	for i in range(5):
		spawn_plant(saguaro_dead)
	for i in range(60):
		spawn_plant(saguaro_small)
	# Animals, too.
	var coyote := preload("res://scenes/coyote.tscn")
	var javelina := preload("res://scenes/javelina.tscn")
	var roadrunner := preload("res://scenes/roadrunner.tscn")
	for i in range(1):
		spawn_plant(coyote)
		spawn_plant(javelina)
		spawn_plant(roadrunner)

@onready var plants: Node3D = $Plants
@onready var _space_state := get_world_3d().direct_space_state
@onready var _limit := Globals.bubble_size
@onready var _rng := Globals.rng

func spawn_plant(scene: PackedScene):
	var tries := 5
	for i in range(tries):
		var angle := _rng.randf() * 2 * PI
		var limit := Globals.bubble_size
		var radius := _rng.randf() * limit
		var pos := Vector3(cos(angle), 1, sin(angle)) * radius
		var to := pos + Vector3(0, -2 * limit, 0)
		var query := PhysicsRayQueryParameters3D.create(pos, to, 1)
		var collision := _space_state.intersect_ray(query)
		if collision["normal"].y < 0.8:
			# Rejection sampling against steep edges.
			continue
		var plant: Node3D = scene.instantiate()
		plant.position += collision.get("position")
		plants.add_child(plant)
		return collision.get("position")
