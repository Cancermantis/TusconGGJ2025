class_name Hands
extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_activate"):
		if sprite.is_playing():
			await sprite.animation_finished
		match sprite.animation:
			"camera_up":
				sprite.play("camera_down")
				await sprite.animation_finished
				sprite.hide()
			_:
				sprite.play("camera_up")
				sprite.visible = true
