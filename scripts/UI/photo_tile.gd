extends TextureRect
class_name PhotoTile

var subjects_present: Array[SubjectInfo]

@onready var save_button: Button = $"SaveButton?"

signal photo_selected(photo: ImageTexture)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _gui_input(event: InputEvent) -> void:
	if(event is not InputEventMouseButton):
		return
	if(event.is_pressed()):
		photo_selected.emit(texture)

func set_photo(photo: ImageTexture, subjects: Array[SubjectInfo]):
	texture = photo
	subjects_present = subjects
	
	var subject_string_array: PackedStringArray
	for subject in subjects:
		subject_string_array.append(subject.name)
	
	tooltip_text = ", ".join(subject_string_array)
