@tool
extends StaticBody3D

@export var option: String = ""
@export var audio_cooldown_min_max: Array[float]
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if option != "":
		sprite.animation = option

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func audio_cooldown():
	pass
