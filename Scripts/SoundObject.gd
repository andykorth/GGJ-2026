extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(destroy_on_finish)
	pass # Replace with function body.

func destroy_on_finish():
	queue_free()
	pass
