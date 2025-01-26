extends Node

var move_controls_shown = false
var photo_controls_shown = true

@export var launchpad: Launchpad

func _on_launch_pad_body_entered(body: Node3D) -> void:
	if(body != Globals.player):
		return
	var tutorial: TutorialWidget = get_tree().get_first_node_in_group("tutorial")
	tutorial.show_tutorial()


func _on_launch_pad_body_exited(body: Node3D) -> void:
	if(body != Globals.player):
		return
	launchpad.end_enabled = true
