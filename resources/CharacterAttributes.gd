class_name CharacterAttributes
extends Resource


@export var character_name: String ## The character's name, shown in dialogue.

@export_range(0.0, 100.0, 0.001) var willingness: float ## The character's willingness to stay at the cafe.

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
