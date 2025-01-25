extends Node

var sounds_playing: Dictionary

func request_play(player: LimitedAudioStreamPlayer):
	if(player.finished.is_connected(_sound_finished.bind(player.limited_sound))):
		return
	if(sounds_playing.has(player.limited_sound)):
		if(sounds_playing[player.limited_sound] >= player.limited_sound.VoiceLimit):
			return
		else:
			sounds_playing[player.limited_sound] += 1
	else:
		sounds_playing[player.limited_sound] = 1
	
	#player.playing = true
	player.play()
	
	player.finished.connect(_sound_finished.bind(player.limited_sound))
#
#func request_play2D(player: LimitedAudioStreamPlayer2D):
	#if(sounds_playing.has(player.limited_sound)):
		#if(sounds_playing[player.limited_sound] >= player.limited_sound.VoiceLimit):
			#return false
		#else:
			#sounds_playing[player.limited_sound] += 1
	#else:
		#sounds_playing[player.limited_sound] = 1
	#
	#player.playing = true
	#player.finished.connect(_sound_finished.bind(player.limited_sound), CONNECT_ONE_SHOT)
	#return true

func _sound_finished(sound: Sound_Limited):
	if(!sounds_playing.has(sound)):
		return
	sounds_playing[sound] -= 1
	
	if(sounds_playing[sound] == 0):
		sounds_playing.erase(sound)

#func _play_sound_at_location(sound: SoundLimited, position: Vector2):
	#if(sound == null):
		#return
	#var player = LimitedAudioStreamPlayer2D.new()
	#player.global_position = position
	#player.limited_sound = sound
	#if(!request_play2D(player)):
		#player.queue_free()
	#else:
		#player.finished.connect(player.queue_free)
