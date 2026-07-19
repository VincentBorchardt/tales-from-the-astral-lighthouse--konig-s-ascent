extends Control

signal cutscene_ended

var cutscene_active = false

@export var messages: Array[Message]
var current_message_index = 0

var DIM = Color(0.385, 0.385, 0.385, 1.0)

@onready var left_image = $LeftSpeaker
@onready var right_image = $RightSpeaker
@onready var message_box = $MessageBox
#@onready var current_speaker = $MessageArea/Speaker
@onready var message_text = $MessageArea/MessageText

# TODO figure out how to do previous messages in this new paradigm

func _input(event: InputEvent) -> void:
	if cutscene_active:
		if Input.is_action_pressed("advance_text"):
			advance_cutscene()

func start_cutscene(message_array):
	messages = message_array
	current_message_index = 0
	# more stuff
	show_message(current_message_index)
	cutscene_active = true
	self.visible = true
	
func show_message(message_index):
	var current_message = messages[message_index]
	if current_message.image_location == Message.Location.LEFT:
		if current_message.speaker.full_picture_left:
			left_image.texture = current_message.speaker.full_picture_left
			left_image.modulate = Color.WHITE
			left_image.visible = true
		else:
			left_image.visible = false
		right_image.modulate = DIM
	elif current_message.image_location == Message.Location.RIGHT:
		if current_message.speaker.full_picture_right:
			right_image.texture = current_message.speaker.full_picture_right
			right_image.modulate = Color.WHITE
			right_image.visible = true
		else:
			right_image.visible = false
		left_image.modulate = DIM
	if current_message.has_box:
		message_box.visible = true
	else:
		message_box.visible = false
	if current_message.color:
		message_text.add_theme_color_override("font_color", current_message.color)
	else:
		message_text.remove_theme_color_override("font_color")
	message_text.visible_characters = 0
	message_text.text = current_message.message
	var tween = create_tween()
	tween.tween_property(message_text, "visible_ratio", 1, 2.0)

func advance_cutscene():
	current_message_index += 1
	if current_message_index >= len(messages):
		cutscene_ended.emit()
		cutscene_active = false
		self.visible = false
		left_image.visible = false
		right_image.visible = false
		
	else:
		show_message(current_message_index)

# TODO capture "next message" input and both increment current_message_index and call show_message
