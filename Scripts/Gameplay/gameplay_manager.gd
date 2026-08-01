extends Node

var enemy_combo : float = 0
var end_of_level : bool = false

func increase_combo():
	enemy_combo += .1
	print(enemy_combo)
	
func reset_combo():
	enemy_combo = 0
