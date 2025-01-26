extends Node

var bubble_size := 99
var player: Player
var rng := RandomNumberGenerator.new()
var seed := 1337
var photo_camera: PhotoCamera
var tool := Tool.NONE:
	get:
		return tool
	set(value):
		tool = value
		tool_changed.emit(tool)
var ui_mode = false

enum Tool {
	NONE,
	CAMERA,
}

signal tool_changed(tool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Globals.rng.seed = seed
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func keep_in_bubble(position: Vector3) -> Vector3:
	var distance := position.length()
	if distance > bubble_size:
		return position.normalized() * bubble_size
	else:
		return position
