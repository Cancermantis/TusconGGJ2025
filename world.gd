extends Node3D

func _ready() -> void:
	Globals.player = $Player
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Capture also on click because web.
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	pass
