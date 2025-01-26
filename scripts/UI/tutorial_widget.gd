extends VBoxContainer
class_name TutorialWidget

var tutorial_over = false;

func show_tutorial():
	var tween = get_tree().create_tween()
	$MoveControls.visible = true;
	$MoveControls.modulate = Color.TRANSPARENT
	# show the move controls
	tween.tween_property($MoveControls, "modulate", Color.WHITE, .1)
	tween.tween_interval(5)
	tween.tween_property($MoveControls, "modulate", Color.TRANSPARENT, .1)
	await tween.tween_interval(.2).finished
	tween = get_tree().create_tween()
	# show the camera controls
	$MoveControls.visible = false;
	$CameraControls.visible = true;
	$CameraControls.modulate = Color.TRANSPARENT
	tween.tween_property($CameraControls, "modulate", Color.WHITE, .1)
	tween.tween_interval(5)
	tween.tween_property($CameraControls, "modulate", Color.TRANSPARENT, .1)
	await tween.tween_interval(.2).finished
	tween = get_tree().create_tween()
	# Show the game instructions
	$CameraControls.visible = false;
	$Instructions.visible = true;
	$Instructions.modulate = Color.TRANSPARENT
	tween.tween_property($Instructions, "modulate", Color.WHITE, .1)
	tween.tween_interval(5)
	tween.tween_property($Instructions, "modulate", Color.TRANSPARENT, .1)
	await tween.tween_interval(.2).finished
	# Set up for control display toggle
	visible = false
	$Instructions.visible = false
	$MoveControls.visible = true
	$MoveControls.modulate = Color.WHITE
	$CameraControls.visible = true
	$CameraControls.modulate = Color.WHITE
	tutorial_over = true

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("toggle_controls")):
		visible = !visible
