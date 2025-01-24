extends Node3D
class_name SoundReceiver

# Simple node that can respond to the simulated volume of a SoundBroadcaster, signaling other objets 
# that it has detected a simulated sound that an object should respond to

# Arbitrary volume value required to trigger this SoundReceiver
@export var threshold: float = 2.0
@export var retrigger: bool = false

var triggered: bool = false

# Signal emitted when the effective volume of a nearby SoundBroadcaster exceeds this Receiver's threshold value
signal sound_received()

# Called when the node enters the scene tree for the first time.
func _check_trigger(volume: float):
	if(volume > threshold && !triggered):
		sound_received.emit()
		if(!retrigger):
			triggered = true
