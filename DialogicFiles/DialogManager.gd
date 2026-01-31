extends Node2D


@export var myNode: Node

func _ready():
	Dialogic.timeline_started.connect($GlobalGameVariables.deactivatePlayerControls)
	Dialogic.timeline_ended.connect($GlobalGameVariables.activatePlayerControls)
	Dialogic.start('Starting Dialog')
	pass
	
func _process(delta):
	pass	
