extends Node2D


@export var myNode: Node

func _ready():
	Dialogic.timeline_started.connect(myNode.disable_movement)
	Dialogic.timeline_ended.connect(myNode.enable_movement)
	Dialogic.start('Starting Dialog')
	pass
	
func _process(delta):
	pass	
