extends Node
@export var sound_object: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_sound():
	var new_sound = sound_object.new()
	add_child(new_sound)
	pass
