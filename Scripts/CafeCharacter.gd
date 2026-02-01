class_name CafeCharacter
extends Node2D

# A character we can move around on the "overworld" map of the cafe.
# Might be scripted to move aroudn, but maybe we allow free movement
# once the mask takes control of a character.

const CHAT_RANGE = 120
const PLAYER_MIN_Y = 590
const PLAYER_MAX_Y = 610

@export var TEST_SOUND_FILE: AudioStream

@export var speed:float = 120.0
@export var spriteScale:float = 0.5
@export var currentChar : CharacterAttributes
@export var cafe : TheCafe

@export var wiggleDegrees:float = 8
@export var bounceAmplitude:float = 0.1

@onready var bodySprite: Sprite2D = $CharacterWorldMapSprite
@onready var maskSprite: Sprite2D = $CharacterWorldMapSprite/maskSprite
@onready var chatIcon: Sprite2D = $CharacterWorldMapSprite/ChatIcon

@export var chatFrame1: Texture
@export var chatFrame2: Texture

@export var stepSound: AudioStreamPlayer

var destination: Vector2
var isWearingMask: bool

var blockedInput: bool = false;
var facing : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position
	destination = position
	Dialogic.timeline_ended.connect(DialogEnded)
	chatIcon.visible = false
	GlobalGameVariables.player = self
	isWearingMask = false
	bodySprite.visible = false;
	maskSprite.visible = false;

func DialogEnded():
	blockedInput = true;
	await get_tree().create_timer(0.1).timeout
	blockedInput = false;
	
func ChangeCharacter(npc : CafeNPC, newChar : CharacterAttributes):
	#probably need to hide the one this turned into
	currentChar = newChar
	# when you become a character, you are wearing a mask by definition:
	isWearingMask = true
	
	bodySprite.texture = currentChar.art_overworld_body_neutral
	maskSprite.texture = currentChar.art_overworld_mask_player
	bodySprite.visible = true;
	maskSprite.visible = isWearingMask
	# set size instantly
	bodySprite.scale = Vector2.ONE * spriteScale
	bodySprite.rotation = 0
	
	# take over a body, swap to their position.
	var oldPlayerPos = position
	position = npc.position
	destination = position
	# clamp position
	ClampPositionAndDestination()
	
	# The NPC should walk home.
	npc.WalkHome(oldPlayerPos)
	
	#anchor to the bottom of the character automatically.
	bodySprite.offset = Vector2(0, -500)
	maskSprite.offset = Vector2(0, -500)

	# Hide the actual NPC version now that we have taken over.
	# but if we swapped off someone, show them again
	cafe.eastonNPC.SetCharVisible(newChar != cafe.eastonNPC.currentChar)
	cafe.lenaNPC.SetCharVisible(newChar != cafe.lenaNPC.currentChar)
	cafe.jesterNPC.SetCharVisible(newChar != cafe.jesterNPC.currentChar and !cafe.jesterNPC.ignore_character_swapping) # Special case.
	cafe.youaNPC.SetCharVisible(newChar != cafe.youaNPC.currentChar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# if dialogic ui is open, return here, so we don't walk around.
	if !GlobalGameVariables.playerControlsActive || blockedInput:
		return
	
	if Time.get_ticks_msec() % 1500 > 750:
		chatIcon.texture = chatFrame1
	else:
		chatIcon.texture = chatFrame2
	
	# process keyboard input as a test, via arrow keys
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var velocity = Vector2.ZERO
	if(input_direction.length_squared() != 0):
		velocity = input_direction * speed
		# moving with keyboard cancels scripted moves.
		destination = position + velocity * delta
	else:
		# if there's no input, use the scripted destination:
		var deltaPos = destination - position
		if(deltaPos.length() < 1.0):
			velocity = Vector2.ZERO
			stepSound.stop()
		else:
			velocity = speed * deltaPos.normalized();
	
	# animate wiggles based on velocity.
	var normalizedSpeed = velocity.length() / speed
	var x = cos(Time.get_ticks_msec() / 80.0)
	bodySprite.rotation = deg_to_rad(x * wiggleDegrees * normalizedSpeed) 

	# flip player art on direction:
	# if velocity is zero, don't change the facing direction
	if velocity.x > 0:
		facing = -1
	elif velocity.x < 0:
		facing = 1

	bodySprite.scale = spriteScale * Vector2(facing,
		cos(Time.get_ticks_msec() / 120.0) * bounceAmplitude * normalizedSpeed + 1.0)
	
	# apply position but need to handle collisions.
	position = position + velocity * delta
	ClampPositionAndDestination()
	
	# need to draw a little chat icon if we are in chat range.
	chatIcon.visible = CheckChatRange() != null

func ClampPositionAndDestination():
	position.y = clamp(position.y, PLAYER_MIN_Y, PLAYER_MAX_Y)
	# clamp destination to our walkable y range
	destination.y = clamp(destination.y, PLAYER_MIN_Y, PLAYER_MAX_Y)

func CheckChatRange() -> CharacterAttributes:
	for childNode in cafe.get_children():
		if childNode is CafeNPC:
			var delta = position - childNode.position
			if delta.length() < CHAT_RANGE && childNode.visible:
				return childNode.currentChar
	return null

# you should NOTICE this cool method
func CheckForNewChats():
	var chatter = CheckChatRange()
	if chatter != null:
		StartDialogWith(chatter)
	
func StartDialogWith(character : CharacterAttributes):
	# stop any additional motion
	destination = position
	
	if GlobalGameVariables.isDialogueActive:
		print("Already in a dialog. Can't start another")
		return
	
	# do blocked input but only when you open the dialog successfully
	print('start dialog with ' + character.character_name);
	print(character.intro_timeline)
	DialogicConnector.startDialogue(character.intro_timeline, character)
	blockedInput = true

func SetDestination(newDest : Vector2):
	if GlobalGameVariables.playerControlsActive && !blockedInput:
		print("Set walk dest to: " + str(newDest) )
		destination = newDest;
		ClampPositionAndDestination()

		stepSound.play()

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		# just for testing
		SetDestination(get_global_mouse_position())

	if Input.is_action_just_pressed("talkaction"):
		# just for testing
		CheckForNewChats()
		
		
