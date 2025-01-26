extends Node

var sounds_playing: Dictionary
var inside_dome: bool = false

func request_play(player: LimitedAudioStreamPlayer):
	if inside_dome == false:
		return
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

func request_play3D(player: LimitedAudioStreamPlayer3D):
	if inside_dome == false:
		return
		
	var connected = false
	if(sounds_playing.has(player.limited_sound)):
		if(sounds_playing[player.limited_sound] >= player.limited_sound.VoiceLimit):
			return false
		else:
			sounds_playing[player.limited_sound] += 1
			connected = true
	else:
		sounds_playing[player.limited_sound] = 1
	
	player.playing = true
	if(!connected):
		player.finished.connect(_sound_finished.bind(player.limited_sound), CONNECT_ONE_SHOT)
	return true

func _sound_finished(sound: Sound_Limited):
	if(!sounds_playing.has(sound)):
		return
	sounds_playing[sound] -= 1
	
	if(sounds_playing[sound] == 0):
		sounds_playing.erase(sound)

func _play_sound_at_location(sound: Sound_Limited, position: Vector3):
	if(sound == null):
		return
	var player = LimitedAudioStreamPlayer3D.new()
	get_tree().current_scene.add_child(player)
	player.global_position = position
	player.limited_sound = sound
	player.limited_play()
	if(!request_play3D(player)):
		player.queue_free()
	else:
		player.finished.connect(player.queue_free)
