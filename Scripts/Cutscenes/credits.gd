extends ScrollContainer

@export var scroll_speed = 50.0

func _process(delta: float) -> void:
	scroll_vertical += delta * scroll_speed
