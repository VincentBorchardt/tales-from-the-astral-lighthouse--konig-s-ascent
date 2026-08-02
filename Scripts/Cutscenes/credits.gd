extends ScrollContainer

@export var scroll_speed: float

var start_scrolling = false

func _process(delta: float) -> void:
	if start_scrolling:
		scroll_vertical += delta * scroll_speed
