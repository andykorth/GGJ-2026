class_name CharacterAttributes
extends Resource

signal willingness_changed


const MAX_WILLINGNESS = 10.0 ## What is considered "max" willingness. When willingness reaches this, the character commits to staying.

@export var character_name: String ## The character's name, shown in dialogue.

@export_group('Willingness')
@export_range(0.0, 10.0, 0.001) var willingness: float: set = _set_willingness_changed ## The character's willingness to stay at the cafe.
@export_range(0.0, 10.0, 0.001) var willingness_mask: float ## The character's willingness to have the mask on. Equal or above is yes, below is no.

@export_group('Character Timelines')
@export var intro_timeline: String ## The name of the character's introduction timeline
@export var timelines_due_to_willingness: Array[String] ## The timelines associated with the characters' willingness

@export_group('Art Assets')
@export_subgroup('Overworld')
@export var art_overworld_body_neutral: Texture
@export var art_overworld_body_positive: Texture
@export var art_overworld_body_negative: Texture
@export var art_overworld_mask_self: Texture
@export var art_overworld_mask_player: Texture

@export_subgroup('Dialogue')
@export var art_dialogue_body: Texture
@export var art_dialogue_face_brows: Texture
@export var art_dialogue_face_eyes: Texture
@export var art_dialogue_face_mouth: Texture
@export var art_dialogue_mask_self: Texture
@export var art_dialogue_mask_player: Texture


func _set_willingness_changed(new_value: float) -> void:
	willingness = clamp(new_value, 0.0, MAX_WILLINGNESS)
	willingness_changed.emit()


## Returns a variable in Dialogic related to the character
func get_dialogic_variable(variable_name: String) -> Variant:
	return Dialogic.VAR.get_variable('%s.%s' % [character_name, variable_name])


## Returns whether the character is currently willing to wear the player mask.
func is_willing_to_wear_mask() -> bool:
	return willingness >= willingness_mask


## Returns whether the character is currently willing to stay for the party.
func is_willing_to_stay() -> bool:
	print('DBG: is_willing_to_stay() willingness %s MAX_WILLINGNESS %s' % [willingness, MAX_WILLINGNESS])
	return willingness == MAX_WILLINGNESS or Dialogic.VAR.get_variable('%s.IsStaying' % [character_name])


## Sets a Dialogic variable related to this character.
## The onus is on you to use the correct value type based on what you set in Dialogic.
func set_dialogic_variable(variable_name: String, value: Variant) -> void:
	Dialogic.VAR.set_variable('%s.%s' % [character_name, variable_name], value)
