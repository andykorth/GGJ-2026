class_name CafeCamera
extends Node2D

# Camera usually follows the character but sometimes
# it gets scripted to do other stuff.

@export var characterNode : CafeCharacter
@export var cameraSpeed : float = 10.0
var panToTarget : bool = false 
var targetPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position
	GlobalGameVariables.cam = self
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if panToTarget:
		var weight = 1 - exp(-cameraSpeed * delta)
		position = position.lerp(targetPos, weight)
		var characterMovementLocked = GlobalGameVariables.playerControlsActive
		if (position - targetPos).length() < 1 && characterMovementLocked:
			panToTarget = false;
	else: 
		var xOffset = -get_viewport().size.x / 2
		position = Vector2(characterNode.position.x + xOffset, 0)

func ScriptedMove(x: float, y: float):
	targetPos = position;
	panToTarget = true
