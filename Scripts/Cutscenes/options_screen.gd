extends Control

signal options_closed
signal play_menu_sound

@onready var debug_option = $DebugOption
@onready var debug_group = $DebugGroup
@onready var trik_check = $DebugGroup/TrikCheck
@onready var mask_check = $DebugGroup/MaskCheck
@onready var pit_check = $DebugGroup/PitCheck
@onready var dsd_check = $DebugGroup/DSDCheck
@onready var npc_count = $DebugGroup/NPCCount

func _on_debug_option_pressed() -> void:
	play_menu_sound.emit()
	debug_group.visible = debug_option.button_pressed

func warp_to_level(level):
	play_menu_sound.emit()
	set_up_npcs()
	get_tree().change_scene_to_file(level)
	

func set_up_npcs():
	if trik_check.is_pressed():
		StoryAutoload.saved_cameos.append(StoryAutoload.trik)
	if mask_check.is_pressed():
		StoryAutoload.saved_cameos.append(StoryAutoload.mask)
	if dsd_check.is_pressed():
		StoryAutoload.saved_cameos.append(StoryAutoload.dsd)
	if pit_check.is_pressed():
		StoryAutoload.saved_cameos.append(StoryAutoload.pit)
	StoryAutoload.total_saved_npcs = int(npc_count.value)

func _on_tutorial_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/tutorial.tscn")

func _on_level_1_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/level_1.tscn")

func _on_level_2_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/level_2.tscn")

func _on_level_3_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/level_3.tscn")

func _on_level_4_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/level_4.tscn")

func _on_level_5_option_pressed() -> void:
	warp_to_level("res://Scenes/Levels/final_level.tscn")


func _on_close_button_pressed() -> void:
	play_menu_sound.emit()
	options_closed.emit()


func _on_visibility_changed() -> void:
	if visible:
		debug_option.grab_focus()
