class_name CafeCharacter
extends Node2D

# A character we can move around on the "overworld" map of the cafe.
# Might be scripted to move aroudn, but maybe we allow free movement
# once the mask takes control of a character.

const CHAT_RANGE = 60
const PLAYER_MIN_Y = 530
const PLAYER_MAX_Y = 700

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

var destination: Vector2
var isWearingMask: bool

var blockedInput: bool = false;

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
	
func ChangeCharacter(newChar : CharacterAttributes):
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
	
	# TODO swap from player mask to normal mask if you are
	# releasing a character.
	
	#anchor to the bottom of the character automatically.
	bodySprite.offset = Vector2(0, -500)
	maskSprite.offset = Vector2(0, -500)
	
	# Hide the actual NPC version now that we have taken over.
	# but if we swapped off someone, show them again
	cafe.eastonNPC.SetCharVisible(newChar != cafe.eastonNPC)
	cafe.lenaNPC.SetCharVisible(newChar != cafe.lenaNPC)
	cafe.jesterNPC.SetCharVisible(newChar != cafe.jesterNPC)
	cafe.youaNPC.SetCharVisible(newChar != cafe.youaNPC)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# if dialogic ui is open, return here, so we don't walk around.
	if !GlobalGameVariables.playerControlsActive || blockedInput:
		return
	
	# process keyboard input as a test, via arrow keys
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var velocity = Vector2.ZERO
	if(input_direction.length_squared() != 0):
		velocity = input_direction * speed
		# moving with keyboard cancels scripted moves.
		destination = position
	else:
		# if there's no input, use the scripted destination:
		var deltaPos = destination - position
		if(deltaPos.length() < 1.0):
			velocity = Vector2.ZERO
		else:
			velocity = speed * deltaPos.normalized();
	
	# animate wiggles based on velocity.
	var normalizedSpeed = velocity.length() / speed
	var x = cos(Time.get_ticks_msec() / 80.0)
	bodySprite.rotation = deg_to_rad(x * wiggleDegrees * normalizedSpeed) 
	bodySprite.scale = spriteScale * Vector2(1, cos(Time.get_ticks_msec() / 120.0) * bounceAmplitude * normalizedSpeed + 1.0)
		
	# apply position but need to handle collisions.
	position = position + velocity * delta
	position.y = clamp(position.y, PLAYER_MIN_Y, PLAYER_MAX_Y)
	
	# need to draw a little chat icon if we are in chat range.
	chatIcon.visible = CheckChatRange() != null


func CheckChatRange() -> CharacterAttributes:
	for childNode in cafe.get_children():
		if childNode is CafeNPC:
			var delta = position - childNode.position
			if delta.length() < CHAT_RANGE:
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
	# do blocked input but only when you open the dialog successfully
	print('start dialog with ' + character.character_name);
	print(character.intro_timeline)
	DialogicConnector.startDialogue(character.intro_timeline, character)
	blockedInput = true

func SetDestination(newDest : Vector2):
	if GlobalGameVariables.playerControlsActive && !blockedInput:
		# clamp destination to our walkable y range
		newDest.y = clamp(newDest.y, PLAYER_MIN_Y, PLAYER_MAX_Y)
		
		print("Set walk dest to: " + str(newDest) )
		destination = newDest;
		SoundPlayer.play_sound(TEST_SOUND_FILE)

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		# just for testing
		SetDestination(get_global_mouse_position())

	if Input.is_action_just_pressed("talkaction"):
		# just for testing
		CheckForNewChats()
		
		
