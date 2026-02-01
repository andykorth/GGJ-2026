class_name CharacterAttributes
extends Resource


@export var character_name: String ## The character's name, shown in dialogue.

@export_group('Willingness')
@export_range(0.0, 10.0, 0.001) var willingness: float ## The character's willingness to stay at the cafe.
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


## Returns whether the character is currently willing to wear the player mask.
func is_willing_to_wear_mask() -> bool:
	return willingness >= willingness_mask
