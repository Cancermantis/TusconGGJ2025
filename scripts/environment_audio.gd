extends Area3D


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_area_entered(area: Area3D) -> void:
	var start_time = randf_range(0,100)
	audio_stream_player.play(start_time)
	AudioManager.inside_dome = true

func _on_area_exited(area: Area3D) -> void:
	audio_stream_player.stop()
	AudioManager.inside_dome = false
