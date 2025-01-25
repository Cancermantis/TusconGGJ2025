class_name Hands
extends Node2D

@onready var camera_display: Sprite2D = $Control/CameraDisplay
@onready var control: Node2D = $Control
@onready var sprite: AnimatedSprite2D = $Control/Sprite
@onready var audio_player: LimitedAudioStreamPlayer = $LimitedAudioStreamPlayer
const OBJ_CAMERA_MISS = preload("res://assets/audio/audioresources/Obj_Camera_Miss.tres")
const OBJ_CAMERA_MVMT = preload("res://assets/audio/audioresources/Obj_Camera_Mvmt.tres")
const OBJ_CAMERA_HIT = preload("res://assets/audio/audioresources/Obj_Camera_Hit.tres")

@export var viewport_texture: SubViewport

func _ready() -> void:
	#camera_display.texture = viewport_texture
	pass

func _process(_delta: float) -> void:
	# TODO This only appears once the camera is full up.
	# TODO Could manually animate the Control wrapper and skip the frames.
	# TODO Or could make the screen black on all the top frame.
	if camera_display.visible:
		var image := viewport_texture.get_texture()
		camera_display.texture = image

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_activate"):
		audio_player.limited_sound = OBJ_CAMERA_MVMT
		if sprite.is_playing():
			await sprite.animation_finished
		match sprite.animation:
			"camera_up":
				Globals.tool = Globals.Tool.NONE
				audio_player.play()
				camera_display.visible = false
				sprite.play("camera_down")
				await sprite.animation_finished
				control.visible = false
			_:
				sprite.play("camera_up")
				audio_player.play()
				control.visible = true
				await sprite.animation_finished
				Globals.tool = Globals.Tool.CAMERA
				camera_display.visible = true

func play_hit_sound():
	audio_player.limited_sound = OBJ_CAMERA_HIT
	audio_player.play()
	
func play_miss_sound():
	audio_player.limited_sound = OBJ_CAMERA_MISS
	audio_player.play()
