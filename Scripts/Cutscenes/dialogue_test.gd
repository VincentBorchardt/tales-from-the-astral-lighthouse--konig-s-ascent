extends Node2D

@export var messages: Array[Message]


func _on_button_pressed() -> void:
	$CutsceneOverlay.start_cutscene(messages)
