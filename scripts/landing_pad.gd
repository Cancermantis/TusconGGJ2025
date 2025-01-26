extends Node
class_name LandingPad

@onready var animation_player: AnimationPlayer = $StartupAnim
const EVENT_INTRO_BUBBLE = preload("res://assets/audio/Event_Intro_Bubble.wav")
const EVENT_INTRO_FLY_IN = preload("res://assets/audio/Event_Intro_FlyIn.wav")
const EVENT_INTRO_LANDING = preload("res://assets/audio/Event_Intro_Landing.wav")
# Called when the node enters the scene tree for the first time.
func _start() -> void:
	animation_player.play("player_enter")
