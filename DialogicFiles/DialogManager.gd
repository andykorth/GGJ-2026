extends Node2D

func _ready():
	Dialogic.timeline_started.connect(GlobalGameVariables.deactivatePlayerControls)
	Dialogic.timeline_ended.connect(GlobalGameVariables.activatePlayerControls)
	Dialogic.Text.about_to_show_text.connect(GlobalGameVariables.incrementDialogStepsTaken)
	Dialogic.start('LenaTest')
	pass
	
func _process(delta):
	pass	
