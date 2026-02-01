extends Node

@export var characterName: String
@export var emotionLayers: Array[Node]
@export var maskLayers: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.VAR.variable_changed.connect(check_layer_change)
	set_character_emotion(0)
	set_character_mask_state(0)
	pass # Replace with function body.

func check_layer_change(change):
	if change.variable == characterName + ".Emotion":
		set_character_layer_emotion_variable(change)
	elif change.variable == characterName + ".WhimsyMaskState":
		if change.new_value == true:
			set_character_mask_state(1)
		else:
			set_character_mask_state(0)
	pass
	
func set_character_emotion(layerToSet):
	for n in emotionLayers.size():
		emotionLayers[n].visible = n == layerToSet
	pass
	
func set_character_mask_state(layerToSet):
	for n in maskLayers.size():
		maskLayers[n].visible = n == layerToSet
	pass

func set_character_layer_emotion_variable(change):
	for n in emotionLayers.size():
		emotionLayers[n].visible = n == change.new_value
	pass
