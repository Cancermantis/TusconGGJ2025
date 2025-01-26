extends Node
class_name LandingPad

@onready var animation_player: AnimationPlayer = $StartupAnim

# Called when the node enters the scene tree for the first time.
func _start() -> void:
	animation_player.play("player_enter")
