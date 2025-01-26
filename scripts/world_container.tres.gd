extends CanvasLayer

@onready var container: SubViewport = $WorldContainer

func _input(event: InputEvent) -> void:
	container.push_input(event)

func _ready() -> void:
	get_tree().paused = true
	Globals.ui_mode = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var tween = get_tree().create_tween()
	tween.tween_property($StartMenu, "modulate", Color.TRANSPARENT, .25)
	tween.tween_property($WorldTexture, "modulate", Color.WHITE, .5)

func _start():
	Globals.ui_mode = false
	$StartMenu/StartButton.visible = false
	get_tree().paused = false
