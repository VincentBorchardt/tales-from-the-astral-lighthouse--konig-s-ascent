extends Control

@export var conversation: Array[Message]
@export var faded_background: Texture2D
@export var next_level: PackedScene

@onready var background = $Background
@onready var cutscene_overlay = $CutsceneOverlay
@onready var credits = $Credits

var blank_message: Array[Message] = [preload("res://Resources/Cutscenes/Endings/blank_message.tres")]

#var DIM = Color(0.125, 0.075, 0.161, 1.0)
#var DIM_SHADER = preload("res://Resources/Cutscenes/purple_dim.gdshader")
var dim_completed = false

func _ready() -> void:
	call_deferred("start_conversation")
	#call_deferred("start_blank")

func start_blank():
	cutscene_overlay.start_cutscene(blank_message, false)

func start_conversation():
	cutscene_overlay.start_cutscene(conversation, false)


func _on_cutscene_overlay_cutscene_ended() -> void:
	credits.visible = true
	credits.start_scrolling = true


func level_change():
	get_tree().change_scene_to_packed(next_level)


func _on_cutscene_overlay_advanced_text() -> void:
	if not dim_completed:
		dim_completed = true
		background.texture = faded_background


func _on_credits_end_credits() -> void:
	get_tree().change_scene_to_file("res://Scenes/Intro/intro_scene.tscn")
