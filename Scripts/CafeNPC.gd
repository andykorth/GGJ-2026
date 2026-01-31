class_name CafeNPC
extends Node2D

# A character that is not us. we can talk to them.

@onready var bodySprite: Sprite2D = $CharacterWorldMapSprite
@export var currentChar : CharacterAttributes = preload('res://resources/Lena.tres')

func _ready() -> void:
	SetUpCharacter()

func SetUpCharacter():
	bodySprite.texture = currentChar.art_overworld_body_neutral
	pass
	
func StartChatWith():
	print("Start a chat with: " + currentChar.character_name)
	DialogicConnector.startDialogue(currentChar.intro_timeline, currentChar)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
