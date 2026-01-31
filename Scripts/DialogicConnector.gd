## Exposes variables for Dialogic to reference.
extends Node


func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_Dialogic_timeline_ended)


func _on_Dialogic_timeline_ended() -> void:
	# DEBUG, remove when not needed.
	print('DBG: End dialogue. Character "%s" has willingness %s, do they want to wear you? %s' % [
		GlobalGameVariables.currentCharacter.character_name,
		GlobalGameVariables.currentCharacter.willingness,
		GlobalGameVariables.currentCharacter.is_willing_to_wear_mask(),
	])
	# Ensure character data is cleared.
	GlobalGameVariables.currentCharacter = null


## Runs all prep work needed for the game before starting a Dialogic dialogue.
func startDialogue(dialogue_name: String, characterAttributes: CharacterAttributes) -> void:
	GlobalGameVariables.currentCharacter = characterAttributes
	print('DBG: character assign %s' % [characterAttributes.character_name])
	Dialogic.start(dialogue_name)
