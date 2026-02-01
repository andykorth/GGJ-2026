## Exposes variables for Dialogic to reference.
extends Node


const jesterCARes = preload('res://resources/JesterCA.tres') ## Only needed for end of game.

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_Dialogic_timeline_started)
	Dialogic.timeline_ended.connect(_on_Dialogic_timeline_ended)
	Dialogic.event_handled.connect(_on_Dialogic_event_handled)


func _on_Dialogic_event_handled(eventResource: DialogicEvent) -> void:
	# print('DBG: Dialogic event happened %s' % [eventResource.event_name])
	if GlobalGameVariables.isGameOver or eventResource.event_name != 'Text':
		return
	
	GlobalGameVariables.incrementDialogStepsTaken()

	if GlobalGameVariables.stepsTakenInDialog > GlobalGameVariables.END_STEPS:
		if GlobalGameVariables.isDialogueActive:
			await Dialogic.timeline_ended
		print('DBG: THE END IS NIGH')
		endGame()


func _on_Dialogic_timeline_started() -> void:
	GlobalGameVariables.isDialogueActive = true


func _on_Dialogic_timeline_ended() -> void:
	# DEBUG, remove when not needed.
	print('DBG: End dialogue. Character "%s" has willingness %s, do they want to wear you? %s' % [
		GlobalGameVariables.currentCharacter.character_name,
		GlobalGameVariables.currentCharacter.willingness,
		GlobalGameVariables.currentCharacter.is_willing_to_wear_mask(),
	])
	# Ensure character data is cleared.
	GlobalGameVariables.currentCharacter = null

	# End dialogue.
	GlobalGameVariables.isDialogueActive = true


func endGame() -> void:
	DialogicConnector.startDialogue(jesterCARes.intro_timeline, jesterCARes)
	GlobalGameVariables.isGameOver = true


## Runs all prep work needed for the game before starting a Dialogic dialogue.
func startDialogue(dialogue_name: String, characterAttributes: CharacterAttributes) -> void:
	GlobalGameVariables.currentCharacter = characterAttributes
	print('DBG: character assign %s' % [characterAttributes.character_name])
	Dialogic.start(dialogue_name)
