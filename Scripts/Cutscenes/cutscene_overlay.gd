extends Control

var cutscene_active = false

@export var messages: Array[Message]
var current_message_index = 0

var DIM = Color(0.385, 0.385, 0.385, 1.0)

@onready var left_image = $LeftSpeaker
@onready var right_image = $RightSpeaker
@onready var current_speaker = $MessageArea/Speaker
@onready var message_text = $MessageArea/MessageText

# TODO figure out how to do previous messages in this new paradigm

func _input(event: InputEvent) -> void:
	if cutscene_active:
		if Input.is_action_pressed("advance"):
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
		left_image.texture = current_message.speaker.full_picture_left
		left_image.modulate = Color.WHITE
		left_image.visible = true
		right_image.modulate = DIM
		
	elif current_message.image_location == Message.Location.RIGHT:
		right_image.texture = current_message.speaker.full_picture_right
		right_image.modulate = Color.WHITE
		right_image.visible = true
		left_image.modulate = DIM
	current_speaker.text = current_message.speaker.name
	message_text.visible_characters = 0
	message_text.text = current_message.message
	var tween = create_tween()
	tween.tween_property(message_text, "visible_ratio", 1, 2.0)

func advance_cutscene():
	current_message_index += 1
	if current_message_index >= len(messages):
		# TODO probably do more than this
		cutscene_active = false
		self.visible = false
		left_image.visible = false
		right_image.visible = false
		
	else:
		show_message(current_message_index)

# TODO capture "next message" input and both increment current_message_index and call show_message
