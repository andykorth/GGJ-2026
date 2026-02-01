class_name CafeCharacter
extends Node2D

# A character we can move around on the "overworld" map of the cafe.
# Might be scripted to move aroudn, but maybe we allow free movement
# once the mask takes control of a character.

const CHAT_RANGE = 60

@export var TEST_SOUND_FILE: AudioStream

@export var speed:float = 120.0
@export var currentChar : CharacterAttributes
@export var cafe : Node

var wiggleAmplitude:float = 1.0
var destination: Vector2
@onready var bodySprite: Sprite2D = $CharacterWorldMapSprite
@onready var chatIcon: Sprite2D = $ChatIcon

var blockedInput: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position
	destination = position
	SetUpCharacter()
	Dialogic.timeline_ended.connect(DialogEnded)
	chatIcon.visible = false


func DialogEnded():
	blockedInput = true;
	await get_tree().create_timer(0.1).timeout
	blockedInput = false;
	
func SetUpCharacter():
	bodySprite.texture = currentChar.art_overworld_body_neutral
	pass

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
	bodySprite.rotation = deg_to_rad(x * 15.0 * normalizedSpeed) 
	bodySprite.scale = Vector2(1, cos(Time.get_ticks_msec() / 120.0) * 0.15 * normalizedSpeed + 1.0)
		
	# apply position but need to handle collisions.
	position = position + velocity * delta
	
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
		print("Set walk dest to: " + str(destination) )
		destination = newDest;
		SoundPlayer.play_sound(TEST_SOUND_FILE)

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		# just for testing
		SetDestination(get_global_mouse_position())

	if Input.is_action_just_pressed("talkaction"):
		# just for testing
		CheckForNewChats()
		
		
