extends VisibleOnScreenNotifier3D
class_name PhotoSubject

@export var subject_data: SubjectInfo

var photo_camera : PhotoCamera

func _ready() -> void:
	photo_camera = get_tree().get_first_node_in_group("photo_camera")
	if (is_on_screen()):
		_on_screen_entered()

func _on_screen_entered() -> void:
	if(photo_camera == null):
		return
	photo_camera.subjects.append(self)


func _on_screen_exited() -> void:
	if(photo_camera == null):
		return
	if (photo_camera.subjects.has(self)):
		photo_camera.subjects.remove_at(photo_camera.subjects.find(self))
