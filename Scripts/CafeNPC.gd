class_name CafeNPC
extends Node2D

# A character that is not us. we can talk to them.

@export var spriteScale:float = 0.5
@onready var bodySprite: Sprite2D = $CharacterWorldMapSprite
@onready var maskSprite: Sprite2D = $CharacterWorldMapSprite/maskSprite
@export var currentChar : CharacterAttributes
var destination: Vector2

@export var speed:float = 120.0

func _ready() -> void:
	destination = position
	SetUpCharacter()

# They only walk when someone sets their destination.
func _process(delta: float) -> void:
	
	# process keyboard input as a test, via arrow keys
	var velocity = Vector2.ZERO

	# NPCs move towards their specified destination
	var deltaPos = destination - position
	if(deltaPos.length() < 1.0):
		velocity = Vector2.ZERO
	else:
		velocity = speed * deltaPos.normalized();
	
	# animate wiggles based on velocity.
	var normalizedSpeed = velocity.length() / speed
	var x = cos(Time.get_ticks_msec() / 80.0)
	bodySprite.rotation = deg_to_rad(x * 15.0 * normalizedSpeed) 
	bodySprite.scale = spriteScale*Vector2(1, cos(Time.get_ticks_msec() / 120.0) * 0.15 * normalizedSpeed + 1.0)
	
	# apply position but need to handle collisions.
	position = position + velocity * delta

func SetUpCharacter():
	if currentChar == null:
		printerr("Missing current character on npc " + self.name)
	if currentChar.art_overworld_body_neutral == null:
		printerr("Missing art_overworld_body_neutral on char " + currentChar.character_name)
	if currentChar.art_overworld_mask_self == null:
		printerr("Missing art_overworld_mask_self on char " + currentChar.character_name)
		
	bodySprite.texture = currentChar.art_overworld_body_neutral
	maskSprite.texture = currentChar.art_overworld_mask_self
	pass
	
func SetDestination(newDest : Vector2):
	print("Set NPC "+self.name+" walk dest to: " + str(destination) )
	destination = newDest;

	
func StartChatWith():
	# If you are already in a chat do not let them start another
	if !GlobalGameVariables.playerControlsActive:
		return
	
	print("Start a chat with: " + currentChar.character_name)
	if currentChar.intro_timeline == null:
		printerr("ERROR, intro_timeline missing for " + currentChar.character_name)
	DialogicConnector.startDialogue(currentChar.intro_timeline, currentChar)
	pass

func SetCharVisible(b : bool):
	if b:
		show()
	else:
		hide()

func HideCharacter():
	print('DBG: hide me %s' % [name])
	hide()

func ShowCharacter():
	print('DBG: show me %s' % [name])
	show()
