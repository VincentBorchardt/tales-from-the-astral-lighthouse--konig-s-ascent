extends Control

signal cutscene_ended
signal advanced_text

var cutscene_active = false
var can_advance_text = false

@export var messages: Array[Message]
var current_message_index = 0

var DIM = Color(0.125, 0.075, 0.161, 1.0)
var DIM_SHADER = preload("res://Resources/Cutscenes/purple_dim.gdshader")

@onready var left_image = $LeftSpeaker
@onready var right_image = $RightSpeaker
@onready var message_box = $MessageBox
@onready var message_box_animation = $MessageBox/AnimationPlayer
@onready var advance_text_marker = $AdvanceTextMarker
#@onready var current_speaker = $MessageArea/Speaker
@onready var message_text = $MessageArea/MessageText

# TODO figure out how to do previous messages in this new paradigm

func _input(event: InputEvent) -> void:
	if cutscene_active and can_advance_text:
		if Input.is_action_pressed("advance_text"):
			advance_cutscene()

func start_cutscene(message_array, has_box=true):
	message_text.visible = false
	messages = message_array
	current_message_index = 0
	cutscene_active = true
	self.visible = true
	if has_box:
		message_box_animation.play("message_box_in")
	else:
		show_message(current_message_index)
	
	
func show_message(message_index):
	can_advance_text = false
	advance_text_marker.visible = false
	var current_message = messages[message_index]
	set_up_message_box(current_message)
	message_text.visible_characters = 0
	message_text.text = current_message.message
	message_text.visible = true
	var tween = create_tween()
	var animation_time = current_message.animation_time
	tween.tween_property(message_text, "visible_ratio", 1, animation_time)
	tween.tween_callback(allow_advance)

func set_up_message_box(current_message):
	if current_message.image_location == Message.Location.LEFT:
		if current_message.speaker.full_picture_left:
			left_image.texture = current_message.speaker.full_picture_left
			var left_x = ceili(left_image.texture.get_width() / 2)
			var left_y = 240 - ceili(left_image.texture.get_height() / 2)
			left_image.position = Vector2(left_x, left_y)
			left_image.modulate = Color.WHITE
			left_image.visible = true
		else:
			left_image.visible = false
		right_image.modulate = DIM
	elif current_message.image_location == Message.Location.RIGHT:
		if current_message.speaker.full_picture_right:
			right_image.texture = current_message.speaker.full_picture_right
			var right_x = 320 - ceili(right_image.texture.get_width() / 2)
			var right_y = 240 - ceili(right_image.texture.get_height() / 2)
			right_image.position = Vector2(right_x, right_y)
			right_image.modulate = Color.WHITE
			right_image.visible = true
		else:
			right_image.visible = false
		left_image.modulate = DIM
	if current_message.has_box:
		message_box.visible = true
	else:
		message_box.visible = false
	if current_message.speaker.font:
		message_text.add_theme_font_override("font", current_message.speaker.font)
	else:
		message_text.remove_theme_font_override("font")
	if current_message.color:
		message_text.add_theme_color_override("font_color", current_message.color)
	else:
		message_text.remove_theme_color_override("font_color")

func allow_advance():
	advance_text_marker.visible = true
	can_advance_text = true
	# TODO blink the marker

func advance_cutscene():
	advanced_text.emit()
	current_message_index += 1
	if current_message_index >= len(messages):
		# TODO animate out the message box, check if it's visible
		if message_box.visible:
			message_text.visible = false
			advance_text_marker.visible = false
			message_box_animation.play("message_box_out")
		else:
			end_cutscene()
		
	else:
		show_message(current_message_index)

func end_cutscene():
	cutscene_ended.emit()
	cutscene_active = false
	self.visible = false
	left_image.visible = false
	right_image.visible = false
