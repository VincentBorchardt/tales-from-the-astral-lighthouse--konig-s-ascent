extends Node2D

@export var messages: Array[Message]

@onready var logo = $Logo
@onready var titles = $Titles
@onready var titles_animation = $Titles/AnimationPlayer
@onready var title_screen = $TitleScreen

func start_intro():
	$CutsceneOverlay.start_cutscene(messages, false)


func _on_cutscene_overlay_cutscene_ended() -> void:
	titles.show()
	logo.hide()
	titles_animation.play("titles_image")

func show_title_screen():
	title_screen.visible = true
	title_screen.start_title_screen()
