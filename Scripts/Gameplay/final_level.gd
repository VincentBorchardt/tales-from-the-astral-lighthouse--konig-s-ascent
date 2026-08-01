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

var initial_total_convo: Array[Message] = initial_part_1
var chosen_ending: EndingChoice

# TODO if I refactor tutorial out of general gameplay, we need scripted_progression_count here

func set_up_cutscenes():
	if StoryAutoload.savedDSD():
		chosen_ending = EndingChoice.DSD
	else:
		pass

func continue_scripted_sequence():
	match scripted_progression_count:
		1:
			match chosen_ending:
				EndingChoice.GOOD:
					pass
				EndingChoice.BAD:
					pass
				EndingChoice.DSD:
					# animate in DSD
					pass

func _on_cutscene_overlay_cutscene_ended() -> void:
	print("ending cutscene")
	get_tree().paused = false
	continue_scripted_sequence()

func _on_booth_warp_out_finished() -> void:
	set_up_cutscenes()
	scripted_progression_count += 1
	start_cutscene(StoryAutoload.tutorial_5)
