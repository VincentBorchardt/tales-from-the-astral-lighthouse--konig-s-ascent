extends Node2D

@export var messages: Array[Message]

@onready var controller_message = $ControllerMessage
@onready var logo = $Logo
@onready var logo_animation = $Logo/AnimationPlayer
@onready var titles = $Titles
@onready var titles_animation = $Titles/AnimationPlayer
@onready var title_screen = $TitleScreen

func start_intro():
	$CutsceneOverlay.start_cutscene(messages, false)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("advance_text"):
		controller_message.visible = false
		logo_animation.play("logo_image")

func _on_cutscene_overlay_cutscene_ended() -> void:
	titles.show()
	logo.hide()
	titles_animation.play("titles_image")

func show_title_screen():
	title_screen.visible = true
	title_screen.start_title_screen()
