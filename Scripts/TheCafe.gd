class_name TheCafe
extends Node2D

@onready var lenaNPC: CafeNPC = $NPCNodeLena
@onready var eastonNPC: CafeNPC = $NPCNodeEaston
@onready var youaNPC: CafeNPC = $NPCNodeYoua
@onready var jesterNPC: CafeNPC = $NPCNodeJester

func _ready() -> void:
	y_sort_enabled = true
	GlobalGameVariables.lenaNPC = lenaNPC
	GlobalGameVariables.eastonNPC = eastonNPC
	GlobalGameVariables.youaNPC = youaNPC
	GlobalGameVariables.jesterNPC = jesterNPC
