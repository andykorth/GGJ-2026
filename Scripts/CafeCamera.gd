class_name CafeCamera
extends Node2D

# Camera usually follows the character but sometimes
# it gets scripted to do other stuff.

@export var characterNode : CafeCharacter
@export var cameraSpeed : float = 1.8
var panToTarget : bool = false 
var targetPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position
	GlobalGameVariables.cam = self
	var xOffset = -get_viewport().size.x / 2
	targetPos = Vector2(characterNode.position.x + xOffset, 0)
	position = targetPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if panToTarget:
		var characterMovementLocked = GlobalGameVariables.playerControlsActive
		if (position - targetPos).length() < 10 && characterMovementLocked:
			panToTarget = false;
	else: 
		var xOffset = -get_viewport().size.x / 2
		targetPos = Vector2(characterNode.position.x + xOffset, 0)
	
	var weight = 1 - exp(-cameraSpeed * delta)
	position = position.lerp(targetPos, weight)

func ScriptedMove(x: float, y: float):
	targetPos = Vector2(x, y);
	panToTarget = true
