extends PanelContainer
class_name SubjectIcon

@onready var icon_texture: TextureRect = $IconTexture

@export var subject_info: SubjectInfo:
	get:
		return subject_info
	set(value):
		subject_info = value
		if(subject_info == null):
			return
		tooltip_text = subject_info.name + "\n" + subject_info.description
		icon_texture.texture = subject_info.icon;
