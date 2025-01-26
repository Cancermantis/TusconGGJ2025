extends Area3D
class_name Launchpad
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
const EVENT_INTRO_FLY_IN = preload("res://assets/audio/Event_Intro_FlyIn.wav")
var interact_prompt_text: PromptPanel
var game_ended = false

var end_screen_template: PackedScene = preload("uid://csobghoi5ix8p")

var player_present = false
var end_enabled = false

func _can_end_game():
	return player_present && end_enabled

func _ready() -> void:
	var ui_root = get_tree().get_first_node_in_group("camera_hidden")
	interact_prompt_text = ui_root.find_child("PromptPanel")

func _input(event: InputEvent) -> void:
	if(game_ended || !_can_end_game()):
		return
	if(event.is_action_pressed("tool_use") && Globals.tool == Globals.Tool.NONE):
		interact_prompt_text.clear_text()
		end_game()

func _on_body_entered(body: Node3D) -> void:
	if(body != Globals.player):
		return
	player_present = true
	if(_can_end_game()):
		interact_prompt_text.set_text("Exit Biosphere")

func _on_body_exited(body: Node3D) -> void:
	if(body != Globals.player):
		return
	player_present = false
	interact_prompt_text.clear_text()

func end_game():
	Globals.player.input_disabled = true
	audio_stream_player.stream = EVENT_INTRO_FLY_IN
	audio_stream_player.play()
	var launch_direction = (-global_basis.z + Vector3(0.0, .75, 0.0)).normalized()
	var destination = Globals.player.global_position + (launch_direction * 50.0)
	var tween = get_tree().create_tween()
	
	var world_texture:TextureRect = get_tree().get_first_node_in_group("world_texture")
	
	tween.tween_property(Globals.player, "global_position", destination, 2.0)
	tween.parallel()
	tween.tween_interval(0.5)
	tween.tween_property(world_texture, "modulate", Color.BLACK, .5)
	await tween.finished
	
	var end_screen = end_screen_template.instantiate()
	var ui_root = get_tree().get_first_node_in_group("camera_hidden")
	
	ui_root.add_child(end_screen)
