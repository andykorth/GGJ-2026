extends Node


var currentCharacter: CharacterAttributes ## The dialogue's current character attributes. This should be set whenever starting a timeline.
var playerControlsActive := true
var stepsTakenInDialog := 0
var cam : CafeCamera
var player : CafeCharacter

# it is helpful to have fixed references to each character
# so we can reference them when swapping characters
var lenaNPC : CafeNPC
var eastonNPC : CafeNPC
var youaNPC : CafeNPC

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activatePlayerControls():
	playerControlsActive = true
	pass
	
func deactivatePlayerControls():
	playerControlsActive = false
	pass

func ChangePlayerCharacter(newCharacter : CharacterAttributes):
	print("Changing character to " + newCharacter.character_name)
	player.ChangeCharacter(newCharacter)

func incrementDialogStepsTaken():
	stepsTakenInDialog += 1
	print(str(stepsTakenInDialog))
	pass

func animateCamera(x : float):
	cam.ScriptedMove(x, 0)
	
