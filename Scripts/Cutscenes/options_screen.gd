extends Control

@onready var debug_option = $DebugOption
@onready var debug_group = $DebugGroup
@onready var trik_check = $DebugGroup/TrikCheck
@onready var mask_check = $DebugGroup/MaskCheck
@onready var pit_check = $DebugGroup/PitCheck
@onready var dsd_check = $DebugGroup/DSDCheck
@onready var npc_count = $DebugGroup/NPCCount

func _on_debug_option_pressed() -> void:
	debug_group.visible = debug_option.button_pressed

func warp_to_level(level):
	pass

func _on_tutorial_option_pressed() -> void:
	pass # Replace with function body.

func _on_level_1_option_pressed() -> void:
	pass # Replace with function body.

func _on_level_2_option_pressed() -> void:
	pass # Replace with function body.

func _on_level_3_option_pressed() -> void:
	pass # Replace with function body.

func _on_level_4_option_pressed() -> void:
	pass # Replace with function body.

func _on_level_5_option_pressed() -> void:
	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	pass # Replace with function body.
