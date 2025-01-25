@tool
extends StaticBody3D

@export var option: String = ""
@onready var audio_cooldown_min_max: Array[float] = [4,12]
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
var loop_timer
const ENV_PLANT_RUSTLE = preload("res://assets/audio/audioresources/Env_Plant_Rustle.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if option != "":
		sprite.animation = option
		loop_timer = Timer.new()
		add_child(loop_timer)
		loop_timer.one_shot = true
		loop_audio()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loop_audio():
	var timer_time = randf_range(audio_cooldown_min_max.min(),audio_cooldown_min_max.max())
	loop_timer.wait_time = timer_time
	loop_timer.timeout.connect(try_play_sound)
	#prints("Working")
	
	
func try_play_sound():
	if abs(Player.global_position - self.global_position) <= ENV_PLANT_RUSTLE.MaxDistance:
		AudioManager._play_sound_at_location(ENV_PLANT_RUSTLE,self.global_position)
	loop_audio()
