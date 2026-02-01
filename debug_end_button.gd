extends Button


const jesterCARes = preload('res://resources/JesterCA.tres')


func _ready() -> void:
    pressed.connect(_on_pressed)


func _on_pressed() -> void:
    DialogicConnector.startDialogue(jesterCARes.intro_timeline, jesterCARes)