extends Control

@export var conversation: Array[Message]
@export var faded_background: Texture2D
@export var next_level: PackedScene
@export var music : AudioStream

@onready var background = $Background
@onready var cutscene_overlay = $CutsceneOverlay
@onready var credits = $Credits
@onready var interaction = $Interaction

var dim_completed = false

func _ready() -> void:
	MusicManager.play_music_from_start( music )
	call_deferred("start_conversation")


func start_conversation():
	cutscene_overlay.start_cutscene(conversation, false)


func _on_cutscene_overlay_cutscene_ended() -> void:
	credits.visible = true
	credits.start_scrolling = true


func level_change():
	MusicManager.stop_music()
	get_tree().change_scene_to_packed(next_level)


func _on_cutscene_overlay_advanced_text() -> void:
	if not dim_completed:
		dim_completed = true
		background.texture = faded_background


func _on_credits_end_credits() -> void:
	interaction.visible = true

func _input(event: InputEvent) -> void:
	if interaction.visible:
		if Input.is_action_pressed("advance_text"):
			get_tree().change_scene_to_file("res://Scenes/Intro/intro_scene.tscn")
