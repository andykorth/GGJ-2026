extends Node
@export var sound_object: AudioStreamPlayer
@export var sound_holder: Node

##Nasty hardcoded stuff that probably shouldn't be here
@export var character_sighs: Array[AudioStream]
@export var character_success_sound: AudioStream
@export var character_fail_sound: AudioStream
var current_willingness

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_sound(sound: AudioStream):
	var new_sound = sound_object.duplicate()
	new_sound.stream = sound
	sound_holder.add_child(new_sound)
	new_sound.play()
	pass
	
func play_current_character_success():
	play_sound(character_success_sound)
	pass

func play_current_character_sigh():
	var soundToPlay = character_sighs[randi_range(0, character_sighs.size() - 1)]
	play_sound(soundToPlay)
	pass
	
func play_current_character_fail():
	play_sound(character_fail_sound)
	pass

func update_willingness_connection():
	GlobalGameVariables.currentCharacter.willingness_changed.connect(play_willingness_sound)
	current_willingness = GlobalGameVariables.currentCharacter.willingness
	pass
	
func play_willingness_sound():
	if GlobalGameVariables.currentCharacter.willingness < current_willingness:
		play_current_character_sigh()
	elif GlobalGameVariables.currentCharacter.willingness > current_willingness:
		play_current_character_success()
	current_willingness = GlobalGameVariables.currentCharacter.willingness
	pass
