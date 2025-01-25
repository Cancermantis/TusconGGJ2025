extends Control

var subject_icon_scene: PackedScene = preload("uid://coatvqonrg2nn")
var photo_tile_scene: PackedScene = preload("uid://dsnhm4a0s1bgb")

@onready var animal_list: HBoxContainer = $PanelContainer/VBoxContainer/AnimalList
@onready var album: HFlowContainer = $PanelContainer/VBoxContainer/HScrollBar/Album


var subjects_identified: Array[SubjectInfo]

func _ready() -> void:
	var subjects_available: Array[SubjectInfo]
	for subject: PhotoSubject in get_tree().get_nodes_in_group("photo_subject"):
		if(subjects_available.has(subject.subject_data)):
			continue
		subjects_available.append(subject.subject_data)
	
	for photo: ImageTexture in Globals.photo_camera.photo_data.keys():
		var photo_tile: PhotoTile = photo_tile_scene.instantiate()
		photo_tile.set_photo(photo, Globals.photo_camera.photo_data[photo])
		album.add_child(photo_tile)		
		photo_tile.photo_selected.connect(_on_photo_clicked)
		
		var subjects_present: Array[SubjectInfo] = Globals.photo_camera.photo_data[photo]
		
		for type: SubjectInfo in subjects_present:
			if(subjects_identified.has(type)):
				continue
			subjects_identified.append(type)
	
	for subject_type in subjects_identified:
		var subject_icon: SubjectIcon = subject_icon_scene.instantiate()
		animal_list.add_child(subject_icon)
		subject_icon.subject_info = subject_type
		subjects_available.erase(subject_type)
	
	if(subjects_available.size() > 0):
		$PanelContainer/VBoxContainer/AnimalList/UnphotographedCount/Count.text = "Missing: x" + str(subjects_available.size())
		$PanelContainer/VBoxContainer/AnimalList/UnphotographedCount.visible = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.ui_mode = true
	grab_focus()

func _on_photo_clicked(photo: ImageTexture):
	$PhotoPreview/Photo.texture = photo
	$PhotoPreview.visible = true


func _on_exit_preview_pressed() -> void:
	$PhotoPreview.visible = false


func _on_end_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, .5)
	tween.tween_interval(.5)
	await tween.finished
	get_tree().change_scene_to_file("uid://bwvtgy22th56p")
