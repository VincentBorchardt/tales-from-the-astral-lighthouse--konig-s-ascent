extends Node

signal shippie_door

var enemy_combo : float = 0
var end_of_level: bool = false:
	set(value):
		end_of_level = value

		if end_of_level:
			shippie_door_open()

func increase_combo():
	enemy_combo += .1
	print(enemy_combo)
	
func reset_combo():
	enemy_combo = 0

func shippie_door_open():
	shippie_door.emit()
