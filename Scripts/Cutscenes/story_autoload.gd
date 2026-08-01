extends Node

var saved_cameos = []
var total_saved_npcs = 0

var tutorial_1_1: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_1.tres")
var tutorial_1_2: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_2.tres")
var tutorial_1_3: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_3.tres")
var tutorial_1_4: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_4.tres")
var tutorial_1_5: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_5.tres")
var tutorial_1_6: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_6.tres")
var tutorial_1_7: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_7.tres")
var tutorial_1_8: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_1_8.tres")
var tutorial_1: Array[Message] = [tutorial_1_1, tutorial_1_2, tutorial_1_3, tutorial_1_4, 
tutorial_1_5, tutorial_1_6, tutorial_1_7, tutorial_1_8]

var tutorial_2_1: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_2_1.tres")
var tutorial_2: Array[Message] = [tutorial_2_1]

var tutorial_3_1: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_3_1.tres")
var tutorial_3_2: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_3_2.tres")
var tutorial_3_3: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_3_3.tres")
var tutorial_3: Array[Message] = [tutorial_3_1, tutorial_3_2, tutorial_3_3]

var tutorial_5_1: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_5_1.tres")
var tutorial_5_2: Message = preload("res://Resources/Cutscenes/Tutorial/tutorial_5_2.tres")
var tutorial_5: Array[Message] = [tutorial_5_1, tutorial_5_2]

var dsd: Speaker = preload("res://Resources/Cutscenes/Speakers/dsd.tres")
var trik: Speaker = preload("res://Resources/Cutscenes/Speakers/trik.tres")
var mask: Speaker = preload("res://Resources/Cutscenes/Speakers/primeval_mask.tres")
var pit: Speaker = preload("res://Resources/Cutscenes/Speakers/pitmaster.tres")

func savedDSD() -> bool:
	return saved_cameos.has(dsd)

func savedTrik() -> bool:
	return saved_cameos.has(trik)

func savedMask() -> bool:
	return saved_cameos.has(mask)

func savedPit() -> bool:
	return saved_cameos.has(pit)
