extends Node2D

func _ready():
	Dialogic.timeline_started.connect(GlobalGameVariables.deactivatePlayerControls)
	Dialogic.timeline_ended.connect(GlobalGameVariables.activatePlayerControls)
	Dialogic.start('Starting Dialog')
	pass
	
func _process(delta):
	pass	
