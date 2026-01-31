extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func PlayGameButton():
	print("Hello global game jam")
	get_tree().change_scene_to_file("res://Cafe.tscn")


func QuitButton():
	get_tree().quit()
	
func CreditsButton():
	OS.shell_open("https://globalgamejam.org/games/2026/masqafe-2")
	
