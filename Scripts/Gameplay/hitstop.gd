extends Node


func stop(duration: float) -> void:
	if Engine.time_scale == 0.0:
		return
	Engine.time_scale = 0.0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
