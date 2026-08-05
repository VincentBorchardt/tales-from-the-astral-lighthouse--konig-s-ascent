extends Control

signal open_options
signal play_menu_sound

@onready var begin_marker = $BeginMarker
@onready var begin_button = $BeginButton
@onready var option_marker = $OptionMarker
@onready var option_button = $OptionButton

func _process(delta: float) -> void:
	if begin_button.has_focus():
		begin_marker.visible = true
	else:
		begin_marker.visible = false
	if option_button.has_focus():
		option_marker.visible = true
	else:
		option_marker.visible = false

func start_title_screen():
	begin_button.grab_focus()


func _on_begin_button_pressed() -> void:
	play_menu_sound.emit()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(preload("res://Scenes/Levels/tutorial.tscn"))


func _on_option_button_pressed() -> void:
	play_menu_sound.emit()
	open_options.emit()
