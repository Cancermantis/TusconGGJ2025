extends Node

var bubble_size := 49

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func keep_in_bubble(position: Vector3) -> Vector3:
	var distance := position.length()
	if distance > bubble_size:
		return position.normalized() * bubble_size
	else:
		return position
