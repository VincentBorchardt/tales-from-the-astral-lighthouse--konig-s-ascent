extends Control

signal unpause
signal restart_level

@onready var continue_marker = $ContinueMarker
@onready var restart_marker = $RestartMarker
@onready var exit_marker = $ExitMarker
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var restart_button = $VBoxContainer/RestartButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var menu_sound = $MenuSound

func _process(delta: float) -> void:
	if continue_button.has_focus():
		continue_marker.visible = true
	else:
		continue_marker.visible = false
	if restart_button.has_focus():
		restart_marker.visible = true
	else:
		restart_marker.visible = false
	if exit_button.has_focus():
		exit_marker.visible = true
	else:
		exit_marker.visible = false

func start_pause_menu():
	menu_sound.play()
	continue_button.grab_focus()

func _on_continue_button_pressed() -> void:
	menu_sound.play()
	unpause.emit()

func _on_restart_button_pressed() -> void:
	menu_sound.play()
	await get_tree().create_timer(0.5).timeout
	restart_level.emit()

func _on_exit_button_pressed() -> void:
	menu_sound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Intro/intro_scene.tscn")
