extends Node
class_name PhotoCamera

@export var ui_group: String = "camera_hidden"
@export var subject_group: String = "photo_subject"
@export var viewport: SubViewport

signal photo_taken(photo : ImageTexture, subject_data)
signal CameraHit
signal CameraMiss


@export var photo_data: Dictionary
var subjects: Array[PhotoSubject]

func _ready() -> void:
	Globals.photo_camera = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tool_use"):
		match Globals.tool:
			Globals.Tool.CAMERA:
				take_photo()
				get_viewport().set_input_as_handled()

func take_photo():
	if(Globals.player == null):
		return
	
	var tree = get_tree();

	# capture the current on-screen image
	var image = viewport.get_texture().get_image()
	#image.resize(image.get_size().x * 2, image.get_size().y * 2)
	var texture = ImageTexture.create_from_image(image)
	var screenshot_path = "user://test.png"
	image.save_png(screenshot_path)
	
	# get all on-screen photo subjects' data
	var subject_data: Array[SubjectInfo] #null for now; will be populated with actual information later
	for subject: PhotoSubject in subjects:
		var distance = subject.global_position.distance_to(Globals.player.global_position)
		if(subject.subject_data.cull_distance < distance):
			continue
		subject_data.append(subject.subject_data)
	if subject_data.size() > 0:
		CameraHit.emit()
	else:
		CameraMiss.emit()
	# store photo subject information along with the photo itself
	photo_data.get_or_add(texture, subject_data)
	photo_taken.emit(texture, subject_data)
