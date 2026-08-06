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

@onready var sequence_timer = $ScriptedSequenceTimer
@onready var plinth = $Plinth
@onready var boyhowdy = $Boyhowdy
@onready var dsd = $Dsd
@onready var eyeball_anim = $Eyeball
@onready var eye_sound = $EyeOpen
@onready var eye_change_sound = $EyeChange
@onready var initial_total_convo: Array[Message] = initial_part_1
var second_total_convo: Array[Message] = []
var cameos_total_convo: Array[Message] = []
var chosen_ending: EndingChoice

# TODO if I refactor tutorial out of general gameplay, we need scripted_progression_count here

func _ready():
	super._ready()
	GameplayManager.set_final_level()
	plinth.play("plinth_move")
	dsd.make_invisible()

func set_up_cutscenes():
	if StoryAutoload.savedDSD():
		chosen_ending = EndingChoice.DSD
		initial_total_convo.append_array(dsd_part_1)
		second_total_convo = good_part_1
	else:
		initial_total_convo.append_array(initial_part_2)
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
	match scripted_progression_count:
		1:
			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					dsd.materialize()
				_:
					# animate in cameos
					scripted_progression_count += 1
					start_cutscene(second_total_convo)
		2:
			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					open_eyeball()
				EndingChoice.BAD:
					scripted_progression_count += 1
					get_tree().change_scene_to_file("res://Scenes/Cutscenes/bad_ending.tscn")
				EndingChoice.GOOD:
					scripted_progression_count += 1
					boyhowdy.start_shooting()
		3:
			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					dsd.move_to_next_target()
				EndingChoice.GOOD:
					scripted_progression_count += 1
					open_eyeball()
				_:
					print("followed a finished ending path")
		4:
			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					sequence_timer.start()
					await  sequence_timer.timeout
					dsd.start_laugh()
				EndingChoice.GOOD:
					scripted_progression_count += 1
					start_cutscene(good_part_3)
		5:
			match chosen_ending:
				EndingChoice.DSD:
					scripted_progression_count += 1
					wave_anim_player.play("fade_to_white")
					await  wave_anim_player.animation_finished
					get_tree().change_scene_to_file("res://Scenes/Cutscenes/dsd_ending.tscn")
		6:
			match chosen_ending:
				EndingChoice.GOOD:
					scripted_progression_count += 1
					get_tree().change_scene_to_file("res://Scenes/Cutscenes/good_ending.tscn")


func _on_cutscene_overlay_cutscene_ended() -> void:
	print("ending cutscene")
	get_tree().paused = false
	call_deferred("continue_scripted_sequence")

func _on_booth_warp_out_finished() -> void:
	set_up_cutscenes()
	scripted_progression_count += 1
	call_deferred("start_cutscene", initial_total_convo)

func absorbed_bullet_threshold_reached():
	boyhowdy.beg()
	sequence_timer.start()
	await  sequence_timer.timeout
	start_cutscene(good_part_2)
	#continue_scripted_sequence()

func _on_boyhowdy_boyhowdy_died() -> void:
	sequence_timer.start()
	await  sequence_timer.timeout
	scripted_progression_count += 1
	start_cutscene(good_part_5)

func open_eyeball():
	eye_sound.play()
	eyeball_anim.play("eye_open")
	await eyeball_anim.animation_finished
	continue_scripted_sequence()


func _on_dsd_movement_finished() -> void:
	eye_change_sound.play()
	plinth.play("dsd_plinth_change")
	await plinth.animation_finished
	plinth.play("dsd_plinth_move")
	eye_sound.play()
	eyeball_anim.play("dsd_eye")
	await eyeball_anim.animation_finished
	continue_scripted_sequence()

func _on_dsd_materialized() -> void:
	start_cutscene(dsd_part_2)

func on_dsd_ready():
	pass

func _on_dsd_laughing_finished() -> void:
		start_cutscene(dsd_part_3)

func _on_boyhowdy_entered_range() -> void:
	start_cutscene(good_part_4)
	boyhowdy.set_entered_range()
