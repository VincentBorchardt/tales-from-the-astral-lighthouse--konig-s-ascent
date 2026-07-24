extends Node2D

signal player_entered

func _on_area_2d_area_entered(area: Area2D) -> void:
	emit_signal("player_entered")
	#transition to next gameplay area
