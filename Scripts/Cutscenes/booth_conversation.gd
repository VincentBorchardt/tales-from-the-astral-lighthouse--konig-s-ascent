extends Control

@export var conversation: Array[Message]
@export var next_level: PackedScene

@onready var cutscene_overlay = $CutsceneOverlay

func _ready() -> void:
	call_deferred("start_conversation")

func start_conversation():
	cutscene_overlay.start_cutscene(conversation)


func _on_cutscene_overlay_cutscene_ended() -> void:
		call_deferred("level_change")


func level_change():
	get_tree().change_scene_to_packed(next_level)
