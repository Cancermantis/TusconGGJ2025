@tool
extends AudioStreamPlayer
class_name LimitedAudioStreamPlayer

@export var limited_sound: Sound_Limited:
	get:
		return limited_sound
	set(value):
		limited_sound = value
		stream = limited_sound.Sound
		max_polyphony = limited_sound.VoiceLimit
		bus = limited_sound.AudioBus
		pitch_scale = limited_sound.PlaybackPitch
#func limited_play():
	#AudioManager.request_play(self)

func _exit_tree():
	finished.emit()
