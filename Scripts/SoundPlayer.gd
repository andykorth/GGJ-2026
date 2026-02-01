extends Node
@export var sound_object: AudioStreamPlayer
@export var sound_holder: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_sound(sound: AudioStream):
	var new_sound = sound_object.duplicate()
	new_sound.stream = sound
	sound_holder.add_child(new_sound)
	new_sound.play()
	pass
