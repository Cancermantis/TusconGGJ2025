extends Node3D

func _ready() -> void:
	Globals.player = $Player

func _process(_delta: float) -> void:
	# Continue to ask for capture for web export after-click reasons.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
