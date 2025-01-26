extends PanelContainer
class_name PromptPanel

@onready var label: Label = $PromptText

var tween: Tween

func set_text(text: String):
	if(tween):
		tween.kill()
	
	visible = true
	label.text = text
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)

func clear_text():
	if(tween):
		tween.kill()

	var tree := get_tree()
	if tree != null:
		tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
		await tween.finished
		visible = false
