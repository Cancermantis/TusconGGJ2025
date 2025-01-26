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

func _make_custom_tooltip(for_text: String) -> Object:
	var text = Label.new()
	text.text = for_text
	text.autowrap_mode = TextServer.AUTOWRAP_WORD
	text.size = Vector2i(200, 50)
	text.custom_minimum_size.x = 300
	text.custom_minimum_size.y = 0
	#tooltip.add_child(text)
	return text
