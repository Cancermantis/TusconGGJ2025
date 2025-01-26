extends CanvasLayer

@onready var container: SubViewport = $WorldContainer

func _input(event: InputEvent) -> void:
	container.push_input(event)

func _ready() -> void:
	#get_tree().paused = true
	Globals.ui_mode = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var tween = get_tree().create_tween()
	tween.tween_property($WorldTexture, "modulate", Color.WHITE, .5)

func _start():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.ui_mode = false
	var tween = get_tree().create_tween()
	#get_tree().paused = false
	tween.tween_property($StartMenu, "modulate", Color.TRANSPARENT, .25)
	await tween.finished
	$StartMenu/StartButton.visible = false
	var landing_pad: LandingPad = get_tree().get_first_node_in_group("starting_anim")
	landing_pad._start()
