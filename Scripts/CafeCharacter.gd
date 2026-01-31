extends Node2D

# A character we can move around on the "overworld" map of the cafe.
# Might be scripted to move aroudn, but maybe we allow free movement
# once the mask takes control of a character.

@export
var speed:float = 120.0;
var wiggleAmplitude:float = 1.0;
var destination: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# process keyboard input as a test, via arrow keys
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var velocity = Vector2.ZERO
	if(input_direction.length_squared() != 0):
		velocity = input_direction * speed
	else:
		# if there's no input, use the scripted destination:
		velocity = speed * (position - destination)
	
	# animate wiggles based on velocity.
	
	# apply position but need to handle collisions.
	position = position + velocity * delta
	
	pass

func SetDestination(newDest : Vector2):
	destination = newDest;

func _physics_process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		# just for testing
		destination = get_local_mouse_position()
		print("Clicked at: " + str(destination) )
