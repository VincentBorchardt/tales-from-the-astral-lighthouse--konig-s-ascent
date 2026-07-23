extends Control

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
