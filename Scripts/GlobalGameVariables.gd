extends Node


const END_STEPS := 10 ## How many text events to process before trigging the endgame.

var currentCharacter: CharacterAttributes ## The dialogue's current character attributes. This should be set whenever starting a timeline.
var playerControlsActive := true
var stepsTakenInDialog := 0
var cam: CafeCamera
var player: CafeCharacter
var isDialogueActive := false ## Dialogic doesn't have an equivalent to this, so this tracks when Dialogic is running a timeline.
var isGameOver := false ## Is the game over?

# it is helpful to have fixed references to each character
# so we can reference them when swapping characters
var lenaNPC: CafeNPC
var eastonNPC: CafeNPC
var youaNPC: CafeNPC
var jesterNPC: CafeNPC

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

func ChangePlayerCharacter(npc : CafeNPC):
	var newCharacter: CharacterAttributes = npc.currentChar
	print("Changing character to " + newCharacter.character_name)
	player.ChangeCharacter(npc, newCharacter)

func ChangePlayerCharacterToLena():
	ChangePlayerCharacter(lenaNPC)
  
func ChangePlayerCharacterToEaston():
	ChangePlayerCharacter(eastonNPC)
  
func ChangePlayerCharacterToYoua():
	ChangePlayerCharacter(youaNPC)

func ChangePlayerCharacterToJester():
	ChangePlayerCharacter(jesterNPC)
	
func MoveLenaNPCTo(x: float, y := 0.0):
	lenaNPC.SetDestination(Vector2(x, y))
func MoveEastonNPCTo(x: float, y := 0.0):
	eastonNPC.SetDestination(Vector2(x, y))
func MoveYouaNPCTo(x: float, y := 0.0):
	youaNPC.SetDestination(Vector2(x, y))
func MoveJesterNPCTo(x: float, y := 0.0):
	jesterNPC.SetDestination(Vector2(x, y))


func incrementDialogStepsTaken():
	stepsTakenInDialog += 1
	print('DBG: steps taken: %s' % [stepsTakenInDialog])
	pass

func animateCamera(x: float):
	print("Starting camera animation: x => " + str(x))
	cam.ScriptedMove(x, 0)

func hideCharacter(character_name: String) -> void:
	# Forgive me, Uncle Bob.
	if lenaNPC and lenaNPC.currentChar.character_name == character_name:
		lenaNPC.HideCharacter()
	elif youaNPC and youaNPC.currentChar.character_name == character_name:
		youaNPC.HideCharacter()
	elif eastonNPC and eastonNPC.currentChar.character_name == character_name:
		eastonNPC.HideCharacter()
	elif jesterNPC and jesterNPC.currentChar.character_name == character_name:
		jesterNPC.HideCharacter()
	else:
		push_error('Character %s not found, aborting.' % [character_name])

func showCharacter(character_name: String) -> void:
	# Forgive me, Uncle Bob.
	if lenaNPC and lenaNPC.currentChar.character_name == character_name:
		lenaNPC.ShowCharacter()
	elif youaNPC and youaNPC.currentChar.character_name == character_name:
		youaNPC.ShowCharacter()
	elif eastonNPC and eastonNPC.currentChar.character_name == character_name:
		eastonNPC.ShowCharacter()
	elif jesterNPC and jesterNPC.currentChar.character_name == character_name:
		jesterNPC.ShowCharacter()
	else:
		push_error('Character %s not found, aborting.' % [character_name])
