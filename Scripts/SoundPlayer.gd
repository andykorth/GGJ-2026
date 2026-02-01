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

func play_current_character_sigh():
	var soundToPlay = GlobalGameVariables.currentCharacter.character_sighs[randi_range(0, GlobalGameVariables.currentCharacter.character_sighs.size() - 1)]
	play_sound(soundToPlay)
	pass
	
func play_current_character_fail():
	play_sound(GlobalGameVariables.currentCharacter.character_fail_sound)
	pass
