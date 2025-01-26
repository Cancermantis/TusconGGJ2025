extends ColorRect

@onready var player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Globals.hit_thorn.connect(hit_thorn)

func _process(_delta: float) -> void:
	pass

func hit_thorn():
	if not player.is_playing():
		player.play("pulse")
