extends Node
class_name PhotoCamera

@export var ui_group: String = "camera_hidden"
@export var subject_group: String = "photo_subject"
@export var player_node: Node3D

signal photo_taken(photo : ImageTexture, subject_data)

@export var photo_data: Dictionary
var subjects: Array[PhotoSubject]

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("take_photo")):
		take_photo()

func take_photo():
	if(player_node == null):
		return
	
	var tree = get_tree();
	# get all currently visible UI elements that shouldn't appear on camera,
	# hide the visible ones, then cache them in an array for later
	var ui_nodes: Array
	for node in tree.get_nodes_in_group(ui_group):
		if node.visible:
			ui_nodes.append(node)
			node.visible = false
			
	tree.paused = true
	await tree.create_timer(.1).timeout
	
	# capture the current on-screen image
	var image = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	#var screenshot_path = "user://test.png"
	#image.get_image().save_png(screenshot_path)
	
	# get all on-screen photo subjects' data
	var subject_data: Array[SubjectInfo] #null for now; will be populated with actual information later
	for subject: PhotoSubject in subjects:
		var distance = subject.global_position.distance_to(player_node.global_position)
		if(subject.subject_data.max_distance < distance):
			continue
		subject_data.append(subject.subject_data)
	
	# store photo subject information along with the photo itself
	
	photo_data.get_or_add(image, subject_data)
	photo_taken.emit(image, subject_data)
	
	# Re-enable visibility of hidden UI elements
	for node in ui_nodes:
		node.visible = true
		
	tree.paused = false
