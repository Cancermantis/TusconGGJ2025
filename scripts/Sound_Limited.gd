extends Resource
class_name Sound_Limited

@export var Sound : AudioStream
@export var VoiceLimit : int = 1
@export_enum("Hero","Animals","Environment","Delay","Reverb","UI") var AudioBus : String
@export var Attenuation : int = 1
@export var MaxDistance : float
@export var PlaybackPitch : float = 1
@export var MaxPolyphony : float = 1
