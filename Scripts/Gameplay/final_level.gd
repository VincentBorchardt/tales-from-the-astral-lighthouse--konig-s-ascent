extends Gameplay

enum EndingChoice {GOOD, BAD, DSD}

@export_group("Normal Conversations")
@export var initial_part_1: Array[Message]
@export var initial_part_2: Array[Message]
@export var initial_part_3: Array[Message]

@export_group("Cameo Conversations")
@export var trik: Array[Message]
@export var primeval_mask: Array[Message]
@export var pitmaster: Array[Message]
@export var pitmaster_alt: Array[Message]

@export_group("Good Ending Conversations")
@export var good_ending_count: int = 10
@export var good_part_1: Array[Message]
@export var good_part_2: Array[Message]
@export var good_part_3: Array[Message]
@export var good_part_4: Array[Message]
@export var good_part_5: Array[Message]

@export_group("Other Ending Conversations")
@export var bad: Array[Message]
@export var dsd_part_1: Array[Message]
@export var dsd_part_2: Array[Message]
@export var dsd_part_3: Array[Message]

@onready var plinth = $Plinth
@onready var boyhowdy = $Boyhowdy
@onready var dsd = $Dsd
@onready var eyeball_anim = $Eyeball
@onready var initial_total_convo: Array[Message] = initial_part_1
var second_total_convo: Array[Message] = []
var cameos_total_convo: Array[Message] = []
var chosen_ending: EndingChoice

# TODO if I refactor tutorial out of general gameplay, we need scripted_progression_count here

func _ready():
	super._ready()
	plinth.play("plinth_move")

func set_up_cutscenes():
	if StoryAutoload.savedDSD():
		chosen_ending = EndingChoice.DSD
		initial_total_convo.append_array(dsd_part_1)
		second_total_convo = dsd_part_2
	else:
		initial_total_convo.append(initial_part_2)
		if StoryAutoload.savedMask():
			cameos_total_convo.append_array(primeval_mask)
			if StoryAutoload.savedPit():
				cameos_total_convo.append_array(pitmaster)
		elif StoryAutoload.savedPit():
			cameos_total_convo.append_array(pitmaster_alt)
		if StoryAutoload.savedTrik():
			cameos_total_convo.append_array(trik)
		second_total_convo.append_array(cameos_total_convo)
		second_total_convo.append_array(initial_part_3)
		if StoryAutoload.total_saved_npcs >= good_ending_count:
			chosen_ending = EndingChoice.GOOD
			second_total_convo.append_array(good_part_1)
		else:
			chosen_ending = EndingChoice.BAD
			second_total_convo.append_array(bad)

func continue_scripted_sequence():
	chosen_ending = EndingChoice.DSD
	match scripted_progression_count:
		1:
			match chosen_ending:
				EndingChoice.DSD:
					
					start_cutscene(dsd_part_2)
					pass
				_:
					# animate in cameos
					pass
			scripted_progression_count += 1
			start_cutscene(second_total_convo)
		2:

			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					dsd.materialize()
				EndingChoice.BAD:
					scripted_progression_count += 1
					get_tree().change_scene_to_file("res://Scenes/Cutscenes/bad_ending.tscn")
				EndingChoice.GOOD:
					start_cutscene(good_part_2)
					boyhowdy.start_shooting()
					pass
		3:
			scripted_progression_count += 1
			match chosen_ending:
				EndingChoice.DSD:
					dsd.move_to_next_target()
				EndingChoice.GOOD:
					start_cutscene(good_part_3)
					boyhowdy.beg()
				_:
					print("followed a finished ending path")
		4:
			match chosen_ending:
				EndingChoice.DSD:
					get_tree().change_scene_to_file("res://Scenes/Cutscenes/dsd_ending.tscn")
			scripted_progression_count += 1

			pass
		5:
			start_cutscene(good_part_4)
			get_tree().change_scene_to_file("res://Scenes/Cutscenes/good_ending.tscn")

func _on_cutscene_overlay_cutscene_ended() -> void:
	print("ending cutscene")
	get_tree().paused = false
	call_deferred("continue_scripted_sequence")

func _on_booth_warp_out_finished() -> void:
	set_up_cutscenes()
	scripted_progression_count += 1
	call_deferred("start_cutscene", initial_total_convo)
	


func _on_boyhowdy_boyhowdy_died() -> void:
	scripted_progression_count += 1
	continue_scripted_sequence()

func open_eyeball():
	eyeball_anim.play("eye_open")
	await eyeball_anim.animation_finished
	
func _on_dsd_movement_finished() -> void:
	eyeball_anim.play("dsd_eye")
	await eyeball_anim.animation_finished
	continue_scripted_sequence()


func _on_dsd_materialized() -> void:
	start_cutscene(dsd_part_3)

func on_dsd_ready():
	# dummies out a signal being connected elsewhere, might not be needed
	pass
