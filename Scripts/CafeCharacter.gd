extends Node2D

# A character we can move around on the "overworld" map of the cafe.
# Might be scripted to move aroudn, but maybe we allow free movement
# once the mask takes control of a character.

@export var speed:float = 120.0
@export var currentChar : CharacterAttributes
var wiggleAmplitude:float = 1.0
var destination: Vector2
@onready var bodySprite: Sprite2D = $CharacterWorldMapSprite

var blockedInput: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position
	destination = position
	SetUpCharacter()
	Dialogic.timeline_ended.connect(DialogEnded)

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
	rotation = deg_to_rad(x * 15.0 * normalizedSpeed) 
	scale = Vector2(1, cos(Time.get_ticks_msec() / 120.0) * 0.15 * normalizedSpeed + 1.0)
	
	# apply position but need to handle collisions.
	position = position + velocity * delta
	pass

func SetDestination(newDest : Vector2):
	if GlobalGameVariables.playerControlsActive && !blockedInput:
		print("Set walk dest to: " + str(destination) )
		destination = newDest;

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		# just for testing
		SetDestination(get_global_mouse_position())
