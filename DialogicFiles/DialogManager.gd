extends Node2D

var _lenaCharacter: CharacterAttributes = preload('res://resources/LenaCA.tres')
var _youaCharacter: CharacterAttributes = preload('res://resources/YouaCA.tres')
var _eastonCharacter: CharacterAttributes = preload('res://resources/EastonCA.tres')

func _ready():
	Dialogic.timeline_started.connect(GlobalGameVariables.deactivatePlayerControls)
	Dialogic.timeline_ended.connect(GlobalGameVariables.activatePlayerControls)
	Dialogic.Text.about_to_show_text.connect(GlobalGameVariables.incrementDialogStepsTaken)
	DialogicConnector.startDialogue(_lenaCharacter.intro_timeline, _lenaCharacter)
	
func _process(delta):
	pass
	
func start_character_dialog(character: CharacterAttributes):
	##var willingnessThreshold
	##var willingnessSplit = 
	
	pass
