class_name TheCafe
extends Node2D

@onready var lenaNPC: CafeNPC = $NPCNodeLena
@onready var eastonNPC: CafeNPC = $NPCNodeEaston
@onready var youaNPC: CafeNPC = $NPCNodeYoua
@onready var jesterNPC: CafeNPC = $NPCNodeJester
@onready var musicPlayer: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	y_sort_enabled = true
	GlobalGameVariables.lenaNPC = lenaNPC
	GlobalGameVariables.eastonNPC = eastonNPC
	GlobalGameVariables.youaNPC = youaNPC
	GlobalGameVariables.jesterNPC = jesterNPC
	GlobalGameVariables.musicPlayer = musicPlayer

func GetNPCs() -> Array[CafeNPC]:
	var list : Array[CafeNPC]
	list.append(lenaNPC)
	list.append(eastonNPC)
	list.append(youaNPC)
	list.append(jesterNPC)
	return list

func FindNPC(c : CharacterAttributes) -> CafeNPC:
	if(c == lenaNPC.currentChar):
		return lenaNPC
	if(c == eastonNPC.currentChar):
		return eastonNPC
	if(c == youaNPC.currentChar):
		return youaNPC
	if(c == jesterNPC.currentChar):
		return jesterNPC
		
	#printerr("Missing npc for character attribute: " + str(c))
	return null
