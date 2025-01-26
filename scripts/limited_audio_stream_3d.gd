@tool
extends AudioStreamPlayer3D
class_name LimitedAudioStreamPlayer3D

@export var limited_sound: Sound_Limited:
	get:
		return limited_sound
	set(value):
		if(limited_sound == value):
			return
		limited_sound = value
		stream = limited_sound.Sound
		max_polyphony =  limited_sound.VoiceLimit
		bus = limited_sound.AudioBus
		#attenuation_model = limited_sound.Attenuation
		max_distance = limited_sound.MaxDistance
		pitch_scale = limited_sound.PlaybackPitch


func limited_play():
	AudioManager.request_play3D(self)

func _exit_tree():
	finished.emit()
