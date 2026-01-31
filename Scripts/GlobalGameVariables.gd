extends Node

static var playerControlsActive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func activatePlayerControls():
	playerControlsActive = true
	pass
	
static func deactivatePlayerControls():
	playerControlsActive = false
	pass
