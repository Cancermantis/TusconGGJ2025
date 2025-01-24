class_name Hands
extends Node2D

@onready var camera_display: Sprite2D = $Control/CameraDisplay
@onready var control: Node2D = $Control
@onready var sprite: AnimatedSprite2D = $Control/Sprite
@onready var hands_audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var shutter_sound
@onready var raise_sound
@onready var lower_sound

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	# TODO This only appears once the camera is full up.
	# TODO Could manually animate the Control wrapper and skip the frames.
	# TODO Or could make the screen black on all the top frame.
	if camera_display.visible:
		var image := ImageTexture.create_from_image(get_viewport().get_texture().get_image())
		camera_display.texture = image

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_activate"):
		if sprite.is_playing():
			await sprite.animation_finished
		match sprite.animation:
			"camera_up":
				Globals.tool = Globals.Tool.NONE
				camera_display.visible = false
				sprite.play("camera_down")
				await sprite.animation_finished
				control.visible = false
			_:
				sprite.play("camera_up")
				control.visible = true
				await sprite.animation_finished
				Globals.tool = Globals.Tool.CAMERA
				camera_display.visible = true
