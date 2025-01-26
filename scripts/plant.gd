extends StaticBody3D

@onready var audio_cooldown_min_max: Array[float] = [4,12]
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var options := sprite.sprite_frames.get_animation_names()
	sprite.animation = options[Globals.rng.randi() % options.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
