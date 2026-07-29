extends Node

var enemy_combo : float = 0


func increase_combo():
	enemy_combo += .1
	print(enemy_combo)
	
func reset_combo():
	enemy_combo = 0
